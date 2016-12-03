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

struct Lexer {
    let input:String
    
    var tokens:[Token] = []
    var identifier:String = ""
    
    var escapeDoubleQuoteOn:Bool = false
    var ignoreNextSpaceOrHTab = false

    init(input: String) {
        self.input = input
    }
    
    mutating func scan() -> [Token] {
        initializeState()
        
        for (_, scanned) in ScanningSequence(input: input) {
            handleSpecialChars(scanned: scanned)
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
    }
    
    private struct SpecialCharSet {
        static let htab:UTF8.CodeUnit = 9
        static let lf:UTF8.CodeUnit = 10
        static let cr:UTF8.CodeUnit = 13
        static let dquote:UTF8.CodeUnit = 22
        static let space:UTF8.CodeUnit = 32
        static let comma:UTF8.CodeUnit = 44
        static let colon:UTF8.CodeUnit = 58
        static let semiColon:UTF8.CodeUnit = 59
        static let equal:UTF8.CodeUnit = 61
    }
        
    private mutating func handleSpecialChars(scanned: ScannedUTF8) {
        guard let current = scanned.current else {
            return
        }
        
        switch current {
        case SpecialCharSet.dquote:
            toggleEscapeDoubleQuote()
        case SpecialCharSet.colon:
            handleCOLON(codeUnit: current)
            break
        case SpecialCharSet.semiColon:
            handleSeparator(tokenType: Token.parameterSeparator)
            break
        case SpecialCharSet.equal:
            handleSeparator(tokenType: Token.parameterValueSeparator)
            break
        case SpecialCharSet.comma:
            handleSeparator(tokenType: Token.multiValueSeparator)
            break
        case SpecialCharSet.cr:
            print("found CR\n")
            break
        case SpecialCharSet.lf:
            handleLineFeed(scanned: scanned)
            break
        case SpecialCharSet.htab, SpecialCharSet.space:
            handleSpaceOrHTab(scanned: scanned)
            break
        default:
            identifier += String(UnicodeScalar(current))
            break
        }
    }
    
    private mutating func toggleEscapeDoubleQuote() {
        escapeDoubleQuoteOn = !escapeDoubleQuoteOn
    }
    
    private mutating func handleCOLON(codeUnit: UTF8.CodeUnit) {
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
    
    private mutating func handleLineFeed(scanned: ScannedUTF8) {
        guard let current = scanned.current,
            let next = scanned.next,
            let preceding = scanned.preceding else {
            return
        }
        
        switch (preceding, next) {
        case (SpecialCharSet.cr, SpecialCharSet.space), (SpecialCharSet.cr, SpecialCharSet.htab):
            // Ignore the linefeed, it is not a content line
            ignoreNextSpaceOrHTab = true
            break
        case (SpecialCharSet.cr, _):
            handleSeparator(tokenType: Token.contentLine)
            break
        case (_, _):
            identifier += String(UnicodeScalar(current))
            break
        }
    }
    
    private mutating func handleSpaceOrHTab(scanned: ScannedUTF8) {
        guard let preceding = scanned.preceding, let current = scanned.current else {
            return
        }
        if (ignoreNextSpaceOrHTab && preceding == SpecialCharSet.lf) {
            ignoreNextSpaceOrHTab = false
        } else {
            identifier += String(UnicodeScalar(current))
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
