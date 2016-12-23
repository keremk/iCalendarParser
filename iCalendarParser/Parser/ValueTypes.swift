//
//  ValueTypes.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/11/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

//    case Boolean
//    case CalendarUserAddress
//    case Date
//    case DateTime
//    case Float
//    case Integer
//    case PeriodOfTime
//    case RecurrenceRule
//    case Text
//    case Time
//    case URI
//    case UTCOffset

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

struct BooleanMapper: ValueMapper {
    internal func mapValue(value: String) -> ValueResult<Bool> {
        var result: ValueResult<Bool>
        if let boolValue = Bool(value.lowercased()) {
            result = ValueResult<Bool>.value(boolValue)
        } else {
            result = ValueResult<Bool>.error(RuleError.UnexpectedValue)
        }
        return result
    }
}

struct TextMapper: ValueMapper {
    internal func mapValue(value: String) -> ValueResult<String> {
        return ValueResult.value(value)
    }
}

struct CalenderUserAddressMapper: ValueMapper {
    internal func mapValue(value: String) -> ValueResult<String> {
        return ValueResult.value(value)
    }
}

struct ComponentValueType: Equatable {
    static func == (lhs: ComponentValueType, rhs: ComponentValueType) -> Bool {
        return true
    }
}
