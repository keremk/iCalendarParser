//
//  DurationLexer.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct DurationLexer {
    let input:String
    
    var tokens:[Token] = []
    var identifier:String = ""
    
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
    }
    
    private struct SpecialCharSet {
        static let time:UTF8.CodeUnit = 0x54 // T
        static let duration:UTF8.CodeUnit = 0x50 // P
        static let week:UTF8.CodeUnit = 0x57 // W
        static let day:UTF8.CodeUnit = 0x44 // D
        static let hour:UTF8.CodeUnit = 0x48 // H
        static let minute:UTF8.CodeUnit = 0x4d // M
        static let second:UTF8.CodeUnit = 0x53 // S
        static let plus:UTF8.CodeUnit = 0x2b // +
        static let minus:UTF8.CodeUnit = 0x2d // -
        static let zero:UTF8.CodeUnit = 0x30 // 0
        static let nine:UTF8.CodeUnit = 0x39 // 9
    }
    
    private mutating func handleSpecialChars(scanned: ScannedUTF8) {
        guard let current = scanned.current else {
            return
        }
        
        switch current {
        case SpecialCharSet.time:
            handleSpecialChar(token: Token.time)
            break
        case SpecialCharSet.duration:
            handleSpecialChar(token: Token.duration)
            break
        case SpecialCharSet.week:
            handleSpecialChar(token: Token.week)
            break
        case SpecialCharSet.day:
            handleSpecialChar(token: Token.day)
            break
        case SpecialCharSet.hour:
            handleSpecialChar(token: Token.hour)
            break
        case SpecialCharSet.minute:
            handleSpecialChar(token: Token.minute)
            break
        case SpecialCharSet.second:
            handleSpecialChar(token: Token.second)
            break
        case SpecialCharSet.plus:
            handleSpecialChar(token: Token.plus)
            break
        case SpecialCharSet.minus:
            handleSpecialChar(token: Token.minus)
            break
        default:
            if (current >= SpecialCharSet.zero && current <= SpecialCharSet.nine) {
                identifier += String(UnicodeScalar(current))
            }
            break
        }
    }
    
    private mutating func handleSpecialChar(token: Token) {
        if (identifier != "") {
            let identifierToken = Token.identifier(identifier)
            tokens.append(identifierToken)
            identifier = ""
        }
        tokens.append(token)
    }
}
