//
//  Parser.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/31/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

public struct Parser {
    public func parse(input: Data) -> ICalendar? {
        guard let node = generateAST(input: input) as? Node<Component> else {
            return nil
        }
        var generator = CalendarGenerator()
        return generator.generate(rootNode: node)
    }
    
    public func generateAST(input: Data) -> TreeNode? {
        guard let inputString = String(data: input, encoding: String.Encoding.utf8) else {
            return nil
        }
        var lexer = Lexer(input: inputString)
        var generator = ASTGenerator()
        let tokens = lexer.scan()
        return generator.generate(tokens: tokens)
    }
}
