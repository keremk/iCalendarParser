//
//  iCalendarLexer.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 11/12/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

// Samples:
// ATTENDEE;RSVP=TRUE;ROLE=REQ-PARTICIPANT;CUTYPE=GROUP:
//  mailto:employee-A@example.com
// ORGANIZER:mailto:jsmith@example.com

enum Token : Equatable {
    case identifier(String)         // String
    case contentLine                // CRLF
    case foldedLine                 // CRLF + (HTAB | SPACE)
    case multiValueSeparator        // COMMA
    case parameterSeparator         // SEMI-COLON
    case valueSeparator             // COLON
    case parameterValueSeparator    // EQUAL
    case doubleQuoteEscape          // DQUOTE
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
        default:
            return false
        }
    }
}

struct Scanner {
    enum SpecialChar : UInt8 {
        case lf = 10
        case cr = 13
        case comma = 44
        case colon = 58
        case semiColon = 59
        case equal = 61
    }
    
    func scan(input: String) -> [Token] {
        var tokens:[Token] = []
        var currentIdentifier = ""
        
        var iterator = input.utf8.enumerated().makeIterator()
        while let (_, codeUnit) = iterator.next() {
            switch codeUnit {
            case 58: // COLON
                handleCOLON(identifier: &currentIdentifier, tokens: &tokens, codeUnit: codeUnit)
                break
            case 59: // SEMI-COLON
                handleSeparator(identifier: &currentIdentifier, tokens: &tokens, tokenType: Token.parameterSeparator)
                break
            case 61: // EQUAL
                handleSeparator(identifier: &currentIdentifier, tokens: &tokens, tokenType: Token.parameterValueSeparator)
                break
            case 44: // COMMA
                handleSeparator(identifier: &currentIdentifier, tokens: &tokens, tokenType: Token.multiValueSeparator)
                break
            case 13: // CR
                break
            case 10: // LF
                handleLineFeed(identifier: &currentIdentifier, tokens: &tokens, codeUnit: codeUnit, iterator: &iterator)
                break
            default:
                currentIdentifier += String(UnicodeScalar(codeUnit))
            }
        }
        if currentIdentifier != "" {
            tokens.append(Token.identifier(currentIdentifier))
        }
        return tokens
    }
    
    private func handleCOLON(identifier: inout String, tokens: inout [Token], codeUnit: UInt8) {
        if isIdentifierURLProtocol(identifier: identifier) {
            identifier += String(UnicodeScalar(codeUnit))
        } else {
            handleSeparator(identifier: &identifier, tokens: &tokens, tokenType: Token.valueSeparator)
        }
    }
    
    private func handleSeparator(identifier: inout String, tokens: inout [Token], tokenType: Token) {
        let identifierToken = Token.identifier(identifier)
        tokens.append(identifierToken)
        tokens.append(tokenType)
        identifier = ""
    }
    
    private func handleLineFeed(identifier: inout String, tokens: inout [Token], codeUnit: UInt8,
                                iterator: inout EnumeratedIterator<String.UTF8View.Iterator>) {
        if let (_, nextUnit) = iterator.next() {
            if (nextUnit == 32 || nextUnit == 9) {
                identifier += String(UnicodeScalar(codeUnit))
            } else {
                handleSeparator(identifier: &identifier, tokens: &tokens, tokenType: Token.contentLine)
                identifier += String(UnicodeScalar(nextUnit))
            }
        } 
    }

    private func isIdentifierURLProtocol(identifier:String) -> Bool  {
        let urlProtocolIdentifiers = ["mailto", "http", "ftp"]
        
        for entry in urlProtocolIdentifiers {
            if (entry == identifier) {
                return true
            }
        }
        return false
    }
}
