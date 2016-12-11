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
    func invokeRule(tokens: [Token]) -> RuleOutput
}

enum RuleError: Error {
    case UnexpectedTokenCount
    case IncorrectSeparator
    case UnexpectedName
    case UnexpectedValue
    case UnexpectedTokenType
    case UndefinedTokenIdentifier
}

enum RuleOutput {
    case Node(Parsable)
    case None(RuleError)
}

struct Rules {
    let ruleSet:[String:Rule] = [
        "BEGIN": ComponentRule(),
        "END": ComponentRule(),
        PropertyName.Version.rawValue: PropertyRule(),
        PropertyName.Summary.rawValue: PropertyRule()
    ]

    public func invokeRule(tokens: [Token]) -> RuleOutput {
        guard let firstToken = tokens.first else {
            return RuleOutput.None(RuleError.UnexpectedTokenCount)
        }
        
        var ruleOutput: RuleOutput
        switch firstToken {
        case .identifier(let identifier):
            if let rule = ruleSet[identifier] {
                ruleOutput = rule.invokeRule(tokens: tokens)
            } else {
                ruleOutput = RuleOutput.None(RuleError.UndefinedTokenIdentifier)
            }
            break
        default:
            ruleOutput = RuleOutput.None(RuleError.UnexpectedTokenType)
        }
        
        return ruleOutput
    }
}
