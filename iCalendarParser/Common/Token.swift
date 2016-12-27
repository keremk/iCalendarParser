//
//  TokenList.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/17/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

// Samples:
// ATTENDEE;RSVP=TRUE;ROLE=REQ-PARTICIPANT;CUTYPE=GROUP:
//  mailto:employee-A@example.com
// ORGANIZER:mailto:jsmith@example.com

protocol TokenProtocol {}

enum Token : Equatable, TokenProtocol {
    case identifier(String)         // String
    case contentLine                // CRLF
    case foldedLine                 // CRLF + (HTAB | SPACE)
    case multiValueSeparator        // COMMA
    case parameterSeparator         // SEMI-COLON
    case valueSeparator             // COLON
    case parameterValueSeparator    // EQUAL
    case doubleQuoteEscape          // DQUOTE
    case time
    case duration
    case week
    case day
    case hour
    case minute
    case second
    case plus
    case minus
}

extension Token {
    public static func ==(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case (let .identifier(stringValue1), let .identifier(stringValue2)):
            return stringValue1 == stringValue2
        case (.contentLine, .contentLine):
            return true
        case (.foldedLine, .foldedLine):
            return true
        case (.multiValueSeparator, .multiValueSeparator):
            return true
        case (.parameterSeparator, .parameterSeparator):
            return true
        case (.valueSeparator, .valueSeparator):
            return true
        case (.parameterValueSeparator, .parameterValueSeparator):
            return true
        case (.doubleQuoteEscape, .doubleQuoteEscape):
            return true
        case (.time, .time):
            return true
        case (.duration, .duration):
            return true
        case (.week, .week):
            return true
        case (.day, .day):
            return true
        case (.hour, .hour):
            return true
        case (.minute, .minute):
            return true
        case (.second, .second):
            return true
        case (.plus, .plus):
            return true
        case (.minus, .minus):
            return true
        default:
            return false
        }
    }
}

extension Array where Element: TokenProtocol {
    typealias SplitTokens = ([[Token]], Int)

    internal func groupTokens2() -> [[Token]] {
        let splitTokens = self.reduce( ([[]], 0)) { (splitTokens, token) -> SplitTokens in
            guard let token = token as? Token else {
                return splitTokens
            }
            var destination = splitTokens.1
            var newTokens:[[Token]] = splitTokens.0
            
            switch token {
            case Token.parameterSeparator:
                destination += 1
                var tokens = splitTokens.0
                tokens.append([])
                newTokens = tokens
                break
            case Token.valueSeparator:
                destination = 0
                var tokens = splitTokens.0[destination]
                tokens.append(token)
                newTokens[destination] = tokens
                break
            default:
                var tokens = splitTokens.0[destination]
                tokens.append(token)
                newTokens[destination] = tokens
            }
            return (newTokens, destination)
        }
        
        return splitTokens.0
    }
    
    internal func groupTokens() -> [[Token]] {
        let tokens = splitTokens(by: Token.valueSeparator)
        
        guard tokens.count == 2 else {
            return [[]]
        }
        
        var leftSideTokens = tokens[0]
        guard leftSideTokens.count >= 1 else {
            return [[]]
        }
        
        let rightSideTokens = tokens[1]
        guard rightSideTokens.count >= 1 else {
            return [[]]
        }

        
        var propertyTokens:[Token] = []
        var parameterTokens:[[Token]] = [[]]

        propertyTokens.append(leftSideTokens[0])
        propertyTokens.append(Token.valueSeparator)

        if leftSideTokens.count > 1 && leftSideTokens[1] == Token.parameterSeparator {
            // This is the type of property with parameters.
            leftSideTokens.removeFirst(2)
            parameterTokens = leftSideTokens.splitTokens(by: Token.parameterSeparator)
        }
        
        if rightSideTokens.count > 1 && rightSideTokens[1] == Token.parameterValueSeparator {
            // This is the type of property with value of parameters
            parameterTokens = rightSideTokens.splitTokens(by: Token.parameterSeparator)
            propertyTokens.append(Token.identifier(""))
        } else {
            propertyTokens.append(contentsOf: rightSideTokens)
        }
        
        return [propertyTokens] + parameterTokens
    }
    
    internal func splitTokens(by: Token) -> [[Token]] {
        let splitTokens = self.reduce( ([[]], 0)) { (splitTokens, token) -> SplitTokens in
            guard let token = token as? Token else {
                return splitTokens
            }
            var destination = splitTokens.1
            var newTokens:[[Token]] = splitTokens.0
            
            switch token {
            case by:
                destination += 1
                var tokens = splitTokens.0
                tokens.append([])
                newTokens = tokens
                break
            default:
                var tokens = splitTokens.0[destination]
                tokens.append(token)
                newTokens[destination] = tokens
            }
            return (newTokens, destination)
        }
        
        return splitTokens.0
    }
    
}
