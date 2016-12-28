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
    case Categories = "CATEGORIES"
}

struct PropertyRule<T: Equatable>: Rule {
    let valueMapper: AnyValueMapper<T>
    let isMultiValued: Bool

    init(valueMapper: AnyValueMapper<T>, isMultiValued: Bool = false) {
        self.valueMapper = valueMapper
        self.isMultiValued = isMultiValued
    }
    
    internal func invokeRule(tokens: [Token]) -> Result<Parsable, RuleError> {
        guard tokens.count >= 3 else {
            return .failure(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == Token.valueSeparator else {
            return .failure(RuleError.IncorrectSeparator)
        }
        
        let nameResult = extractName(token: tokens[0])
        var valueTokens = tokens
        valueTokens.removeFirst(2)
        let valuesResult = extractValues(tokens: valueTokens)
        
        var ruleOutput:Result<Parsable, RuleError>
        switch (nameResult, valuesResult) {
        case(.success(let name), .success(let multiValued)):
            if !isMultiValued {
                // Single value
                let nodeValue = NodeValue.Property(name, multiValued.values[0])
                let node = Node(nodeValue: nodeValue)
                ruleOutput = .success(node)
            } else {
                let nodeValue = NodeValue.Property(name, multiValued)
                let node = Node(nodeValue: nodeValue)
                ruleOutput = .success(node)
            }
            break
        case(.failure(let error), _):
            ruleOutput = .failure(error)
            break
        case(_, .failure(let error)):
            ruleOutput = .failure(error)
            break
        default:
            ruleOutput = .failure(RuleError.UnexpectedValue)
            break
        }
        
        return ruleOutput
    }
    
    private func extractName(token: Token) -> Result<PropertyName, RuleError> {
        if case .identifier(let stringValue) = token,
            let name = PropertyName(rawValue: stringValue) {
            return .success(name)
        } else {
            return .failure(RuleError.UnexpectedName)
        }
    }
    
    private func extractValue(token: Token) -> Result<T, RuleError> {
        switch token {
        case .identifier(let value):
            return valueMapper.mapValue(value: value)
        default:
            return .failure(RuleError.UnexpectedTokenType)
        }
    }
    
    private func appendToMultiValued(multiValued: Result<MultiValued<T>, RuleError>, element: Result<T, RuleError>) -> Result<MultiValued<T>, RuleError> {
        switch (element, multiValued) {
        case (.success(let value), .success(let multiValues)):
            var newValues = multiValues.values
            newValues.append(value)
            return Result<MultiValued<T>, RuleError>.success(MultiValued<T>(values:newValues))
        case (.failure(let error), _):
            return Result<MultiValued<T>, RuleError>.failure(error)
        default:
            return multiValued
        }
    }
    
    private func extractValues(tokens: [Token]) -> Result<MultiValued<T>, RuleError> {
        let initial = Result<MultiValued<T>, RuleError>.success(MultiValued<T>(values:[]))
        return tokens.filter({$0 != Token.multiValueSeparator }).map(extractValue).reduce(initial, appendToMultiValued)
    }
}
