//
//  Rules.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

typealias RuleHandler<T: Comparable> = ([Token]) -> Node<T>

protocol Rule {
    func invokeRule(tokens: [Token]) -> Result<Parsable, RuleError>
}

enum RuleError: Error {
    case UnexpectedTokenCount
    case IncorrectSeparator
    case UnexpectedName
    case UnexpectedValue
    case UnexpectedTokenType
    case UndefinedTokenIdentifier
}

struct Rules: Rule {
    let ruleSet:[String:Rule] = [
        "BEGIN": ComponentRule(),
        "END": ComponentRule(),
        PropertyName.Version.rawValue: PropertyRule(),
        PropertyName.Summary.rawValue: PropertyRule(),
        PropertyName.Attendee.rawValue: PropertyRule(),
        ParameterName.Rsvp.rawValue: ParameterRule(valueMapper: AnyValueMapper(BooleanMapper())),
        ParameterName.Cutype.rawValue: ParameterRule(valueMapper: AnyValueMapper(TextMapper()))
    ]

    public func invokeRule(tokens: [Token]) -> Result<Parsable, RuleError> {
        guard let firstToken = tokens.first else {
            return .failure(RuleError.UnexpectedTokenCount)
        }
        
        var ruleOutput: Result<Parsable, RuleError>
        switch firstToken {
        case .identifier(let identifier):
            if let rule = ruleSet[identifier] {
                ruleOutput = rule.invokeRule(tokens: tokens)
            } else {
                ruleOutput = .failure(RuleError.UndefinedTokenIdentifier)
            }
            break
        default:
            ruleOutput = .failure(RuleError.UnexpectedTokenType)
        }
        
        return ruleOutput
    }
}
