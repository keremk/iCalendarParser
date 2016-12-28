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
    
    internal func invokeRule(tokens: [Token]) -> Result<Parsable, RuleError> {
        guard tokens.count >= 3 else {
            return .failure(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == Token.parameterValueSeparator else {
            return .failure(RuleError.IncorrectSeparator)
        }
        
        var ruleOutput:Result<Parsable, RuleError>
        switch (tokens[0], tokens[2]) {
        case (.identifier(let name), .identifier(let value)):
            if let name = ParameterName(rawValue: name) {
                let mappedValue = valueMapper.mapValue(value: value)
                switch mappedValue {
                case .success(let innerValue):
                    let nodeValue = NodeValue.Parameter(name, innerValue)
                    let node = Node(nodeValue: nodeValue)
                    ruleOutput = .success(node)
                case .failure(let error):
                    ruleOutput = .failure(error)
                }
            } else {
                ruleOutput = .failure(RuleError.UnexpectedName)
            }
            break
        default:
            ruleOutput = .failure(RuleError.UnexpectedTokenType)
            break
        }
        
        return ruleOutput
    }
}
