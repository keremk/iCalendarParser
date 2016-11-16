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
    let input:String
    
    var tokens:[Token] = []
    var escapeDoubleQuoteOn:Bool = false
    var identifier:String = ""
    var iterator:EnumeratedIterator<String.UTF8View.Iterator> = "".utf8.enumerated().makeIterator()
    
    init(input: String) {
        self.input = input
    }
    
    mutating func scan() -> [Token] {
        initializeState()
        
        while let (_, codeUnit) = iterator.next() {
            if !handleSpecialChars(codeUnit: codeUnit) {
                identifier += String(UnicodeScalar(codeUnit))
            }
        }
        if identifier != "" {
            tokens.append(Token.identifier(identifier))
        }
        return tokens
    }
    
    private mutating func initializeState() {
        tokens = []
        identifier = ""
        escapeDoubleQuoteOn = false
        iterator = input.utf8.enumerated().makeIterator()
    }
    
    private enum SChar : UInt8 {
        case lf = 10
        case cr = 13
        case dquote = 22
        case comma = 44
        case colon = 58
        case semiColon = 59
        case equal = 61
    }
    
    private mutating func handleSpecialChars(codeUnit: UInt8) -> Bool {
        var specialCharFound = true
        if let codeUnitSelector = SChar(rawValue: codeUnit) {
            switch codeUnitSelector {
            case .dquote:
                toggleEscapeDoubleQuote()
            case .colon:
                handleCOLON(codeUnit: codeUnit)
                break
            case .semiColon:
                handleSeparator(tokenType: Token.parameterSeparator)
                break
            case .equal:
                handleSeparator(tokenType: Token.parameterValueSeparator)
                break
            case .comma:
                handleSeparator(tokenType: Token.multiValueSeparator)
                break
            case .cr:
                break
            case .lf:
                handleLineFeed(codeUnit: codeUnit)
                break
            }
        } else {
            specialCharFound = false
        }
        return specialCharFound
    }
    
    private mutating func toggleEscapeDoubleQuote() {
        escapeDoubleQuoteOn = !escapeDoubleQuoteOn
    }
    
    private mutating func handleCOLON(codeUnit: UInt8) {
        if isIdentifierURLProtocol(identifier: identifier) {
            identifier += String(UnicodeScalar(codeUnit))
        } else {
            handleSeparator(tokenType: Token.valueSeparator)
        }
    }
    
    private mutating func handleSeparator(tokenType: Token) {
        if (identifier != "") {
            let identifierToken = Token.identifier(identifier)
            tokens.append(identifierToken)
        }
        tokens.append(tokenType)
        identifier = ""
    }
    
    private mutating func handleLineFeed(codeUnit: UInt8) {
        if let (_, nextUnit) = iterator.next() {
            if (nextUnit == 32 || nextUnit == 9) {
                identifier += String(UnicodeScalar(codeUnit))
            } else {
                handleSeparator(tokenType: Token.contentLine)
                if !handleSpecialChars(codeUnit: nextUnit) {
                    identifier += String(UnicodeScalar(nextUnit))
                }
            }
        } 
    }

    private func isIdentifierURLProtocol(identifier:String) -> Bool  {
        let urlProtocolIdentifiers = ["mailto", "http", "https", "ftp"]
        
        for entry in urlProtocolIdentifiers {
            if (entry == identifier) {
                return true
            }
        }
        return false
    }
}
