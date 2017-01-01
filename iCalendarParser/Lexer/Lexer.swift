//
//  iCalendarLexer.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 11/12/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

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
        static let space:UTF8.CodeUnit = 32
        static let dquote:UTF8.CodeUnit = 34
        static let comma:UTF8.CodeUnit = 44
        static let colon:UTF8.CodeUnit = 58
        static let semiColon:UTF8.CodeUnit = 59
        static let equal:UTF8.CodeUnit = 61
        static let backslash:UTF8.CodeUnit = 92
    }
        
    private mutating func handleSpecialChars(scanned: ScannedUTF8) {
        guard let current = scanned.current else {
            return
        }
        
        switch current {
        case SpecialCharSet.dquote:
            toggleEscapeDoubleQuote()
            break
        case SpecialCharSet.colon:
            handleColon(codeUnit: current)
            break
        case SpecialCharSet.semiColon:
            handleSeparator(codeUnit: current, tokenType: Token.parameterSeparator)
            break
        case SpecialCharSet.equal:
            handleSeparator(codeUnit: current, tokenType: Token.parameterValueSeparator)
            break
        case SpecialCharSet.comma:
            handleComma(scanned: scanned)
            break
        case SpecialCharSet.cr:
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
    
    private mutating func handleColon(codeUnit: UTF8.CodeUnit) {
        guard !escapeDoubleQuoteOn else {
            identifier += String(UnicodeScalar(codeUnit))
            return
        }
        
        if isIdentifierURLProtocol(identifier: identifier) {
            identifier += String(UnicodeScalar(codeUnit))
        } else {
            handleSeparator(codeUnit: codeUnit, tokenType: Token.valueSeparator)
        }
    }
    
    private mutating func handleComma(scanned: ScannedUTF8) {
        guard let current = scanned.current,
            let preceding = scanned.preceding else {
                return
        }
        
        switch preceding {
        case SpecialCharSet.backslash:
            identifier += String(UnicodeScalar(current))
            break
        default:
            handleSeparator(codeUnit: current, tokenType: Token.multiValueSeparator)
            break
        }
    }
    
    private mutating func handleSeparator(codeUnit: UTF8.CodeUnit, tokenType: Token) {
        guard !escapeDoubleQuoteOn else {
            identifier += String(UnicodeScalar(codeUnit))
            return
        }

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
            handleSeparator(codeUnit: current, tokenType: Token.contentLine)
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
