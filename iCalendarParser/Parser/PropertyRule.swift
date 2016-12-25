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
    case Attendee = "ATTENDEE"
}

struct PropertyRule: Rule {
    internal func invokeRule(tokens: [Token]) -> Result<Parsable, RuleError> {
        guard tokens.count >= 3 else {
            return Result.failure(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == Token.valueSeparator else {
            return Result.failure(RuleError.IncorrectSeparator)
        }
        
        var ruleOutput:Result<Parsable, RuleError>
        switch (tokens[0], tokens[2]) {
        case (.identifier(let name), .identifier(let value)):
            if let propertyName = PropertyName(rawValue: name) {
                let nodeValue = NodeValue.Property(propertyName, value)
                let node = Node(nodeValue: nodeValue)
                ruleOutput = Result.success(node)
            } else {
                ruleOutput = Result.failure(RuleError.UnexpectedName)
            }
            break
        default:
            ruleOutput = Result.failure(RuleError.UnexpectedTokenType)
            break
        }
        
        return ruleOutput
    }
}
