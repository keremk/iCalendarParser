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

struct ParameterRule<T: Equatable>: Rule {
    let valueMapper: AnyValueMapper<T>
    
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
            if let name = ParameterName(rawValue: name) {
                let mappedValue:ValueResult<T> = valueMapper.mapValue(value: value)
                switch mappedValue {
                case .value(let innerValue):
                    let nodeValue = NodeValue.Parameter(name, innerValue)
                    let node = Node(nodeValue: nodeValue)
                    ruleOutput = RuleOutput.Node(node)
                case .error(let error):
                    ruleOutput = RuleOutput.None(error)
                }
                
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
