//
//  DefaultRule.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/28/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct DefaultRule<T: Equatable>: Rule {
    let valueMapper: AnyValueMapper<T>
    let nodeType: NodeType
    let isMultiValued: Bool
    let multiValueSeparator: Token
    
    var separator:Token {
        get {
            switch nodeType {
            case .container:
                return Token.valueSeparator
            case .parameter:
                return Token.parameterValueSeparator
            case .property:
                return Token.valueSeparator
            }
        }
    }
    
    init(valueMapper: AnyValueMapper<T>, nodeType: NodeType,
         isMultiValued: Bool = false, multiValueSeparator: Token = Token.multiValueSeparator) {
        self.valueMapper = valueMapper
        self.nodeType = nodeType
        self.isMultiValued = isMultiValued
        self.multiValueSeparator = multiValueSeparator
    }
    
    internal func invokeRule(tokens: [Token]) -> Result<TreeNode, RuleError> {
        guard tokens.count >= 3 else {
            return .failure(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == separator else {
            return .failure(RuleError.IncorrectSeparator)
        }
        
        let nameResult = extractName(token: tokens[0])
        var valueTokens = tokens
        valueTokens.removeFirst(2)
        let valuesResult = extractValues(tokens: valueTokens)
        
        var ruleOutput:Result<TreeNode, RuleError>
        switch (nameResult, valuesResult) {
        case(.success(let name), .success(let multiValued)):
            if !isMultiValued {
                let nodeValue = multiValued.values[0]
                let node = Node(name: name, value: nodeValue, type: nodeType)
                ruleOutput = .success(node)
            } else {
                let nodeValue = multiValued
                let node = Node(name: name, value: nodeValue, type: nodeType)
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
    
    private func extractName(token: Token) -> Result<ElementName, RuleError> {
        if case .identifier(let stringValue) = token,
            let name = ElementName(rawValue: stringValue) {
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
        return tokens.filter({$0 != multiValueSeparator }).map(extractValue).reduce(initial, appendToMultiValued)
    }
}
