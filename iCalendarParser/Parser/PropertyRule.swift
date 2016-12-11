//
//  PropertyRule.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/10/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

enum PropertyName: String, RawRepresentable {
    case Version = "VERSION"
    case Description = "DESCRIPTION"
    case Summary = "SUMMARY"
}

struct PropertyRule: Rule {
    internal func invokeRule(tokens: [Token]) -> RuleOutput {
        guard tokens.count >= 3 else {
            return RuleOutput.None(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == Token.valueSeparator else {
            return RuleOutput.None(RuleError.IncorrectSeparator)
        }
        
        var ruleOutput:RuleOutput
        switch (tokens[0], tokens[2]) {
        case (.identifier(let name), .identifier(let value)):
            if let propertyName = PropertyName(rawValue: name) {
                let nodeValue = NodeValue.Property(propertyName, value)
                let node = Node(nodeValue: nodeValue)
                ruleOutput = RuleOutput.Node(node)
            } else {
                ruleOutput = RuleOutput.None(RuleError.UnexpectedName)
            }
            break
        default:
            ruleOutput = RuleOutput.None(RuleError.UnexpectedTokenType)
            break
        }
        
        return ruleOutput
    }
}
