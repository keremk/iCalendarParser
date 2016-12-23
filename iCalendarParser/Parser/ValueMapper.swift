//
//  ValueMapper.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

enum ValueResult<T: Equatable>: Equatable {
    case value(T)
    case error(RuleError)
    
    static func == (lhs: ValueResult, rhs: ValueResult) -> Bool {
        switch (lhs, rhs) {
        case (.value(let lhsInnerValue), .value(let rhsInnerValue)):
            return lhsInnerValue == rhsInnerValue
        default:
            return false
        }
    }
    
    func flatMap() -> T? {
        switch self {
        case .value(let innerValue):
            return innerValue
        case .error:
            return nil
        }
    }
}

protocol ValueMapper {
    associatedtype ValueType: Equatable
    func mapValue(value: String) -> ValueResult<ValueType>
}

// As of Swift 3.01, we cannot directly inject a type that complies to a protocol with a generic associated type.
// We need to inject this ParameterRule and Property to rule to convert a String to a desired type.
// So we are using a technique called Type Erasure (See https://krakendev.io/blog/generic-protocols-and-their-shortcomings)
// We basically wrap our concrete mapper that knows how to map to a concrete type with this AnyValueMapper type.
struct AnyValueMapper<T: Equatable>: ValueMapper {
    private let _mapValue: (String) -> ValueResult<T>
    
    init<U:ValueMapper>(_ valueMapper: U) where U.ValueType == T {
        _mapValue = valueMapper.mapValue
    }
    
    func mapValue(value: String) -> ValueResult<T> {
        return _mapValue(value)
    }
}
