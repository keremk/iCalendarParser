//
//  ParameterRule.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/10/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

enum ParameterName: String, RawRepresentable {
    case AltRep = "ALTREP"
    case Rsvp = "RSVP"
    case Cutype = "CUTYPE"
}

struct ParameterRule: Rule {
    internal func invokeRule(tokens: [Token]) -> RuleOutput {
        guard tokens.count >= 3 else {
            return RuleOutput.None(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == Token.parameterValueSeparator else {
            return RuleOutput.None(RuleError.IncorrectSeparator)
        }
        
        var ruleOutput:RuleOutput
        switch (tokens[0], tokens[2]) {
        case (.identifier(let name), .identifier(let value)):
            if let propertyName = ParameterName(rawValue: name) {
                let nodeValue = NodeValue.Parameter(propertyName, value)
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
