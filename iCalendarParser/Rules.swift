//
//  Rules.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

typealias RuleHandler<T: Comparable> = ([Token]) -> Node<T>

struct Rules {
    let ruleSet = [
        "BEGIN": beginHandler
    ]

    public func invokeRule(tokens: [Token]) -> Any? {
        guard tokens.count > 1 else {
            return nil
        }
        
        let firstToken = tokens[0]
        var node:Any?

        switch firstToken {
        case .identifier(let identifier):
            if let ruleHandler = ruleSet[identifier] {
                node = ruleHandler(self)(tokens)
            }
            break
        default:
            return nil
        }
        
        return node
    }
    
    private func beginHandler(tokens: [Token]) -> Node<String>? {
        guard tokens.count >= 3 else {
            return nil
        }
        guard tokens[1] == Token.valueSeparator else {
            return nil
        }
        
        var node:Node<String>?
        switch (tokens[0], tokens[2]) {
        case (.identifier(let name), .identifier(let value)):
            node = Node(name: name, value: value)
            break
        default:
            node = nil
            break
        }
        
        return node
    }
}
