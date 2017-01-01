//
//  Parser.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/31/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct Parser {
    public func parse(input: Data) -> TreeNode? {
        guard let inputString = String(data: input, encoding: String.Encoding.utf8) else {
            return nil
        }
        var lexer = Lexer(input: inputString)
        var generator = ASTGenerator()
        let tokens = lexer.scan()
        return generator.generate(tokens: tokens)
    }
}
