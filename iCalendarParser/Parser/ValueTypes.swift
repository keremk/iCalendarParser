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

protocol ValueMapper {
    associatedtype ValueType: Equatable
    func mapValue(value: String) -> ValueType
}

// As of Swift 3.01, we cannot directly inject a type that complies to a protocol with a generic associated type.
// We need to inject this ParameterRule and Property to rule to convert a String to a desired type.
// So we are using a technique called Type Erasure (See https://krakendev.io/blog/generic-protocols-and-their-shortcomings)
// We basically wrap our concrete mapper that knows how to map to a concrete type with this AnyValueMapper type.
struct AnyValueMapper<T: Equatable>: ValueMapper {
    private let _mapValue: (String) -> T
    
    init<U:ValueMapper>(_ valueMapper: U) where U.ValueType == T {
        _mapValue = valueMapper.mapValue
    }
    
    func mapValue(value: String) -> T {
        return _mapValue(value)
    }
}

struct BooleanMapper: ValueMapper {
    internal func mapValue(value: String) -> Bool {
        return value.toBool()
    }
}

struct TextMapper: ValueMapper {
    internal func mapValue(value: String) -> String {
        return value
    }
}

struct CalenderUserAddressMapper: ValueMapper {
    internal func mapValue(value: String) -> String {
        return value
    }
}

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

struct DateMapper: ValueMapper {
    internal func mapValue(value: String) -> ValueResult<Date> {
        var result:ValueResult<Date>
        
        if let results = parseValue(value: value),
           let date = dateFrom(year: results.0, month: results.1, day: results.2) {
            result = ValueResult.value(date)
        } else {
            result = ValueResult.error(RuleError.UnexpectedValue)
        }
        
        return result
    }
    
    private func parseValue(value: String) -> (Int, Int, Int)? {
        guard value.utf8.count == 8 else {
            return nil
        }
       
        guard let year = Int(value[0..<4]) else {
            return nil
        }
        
        guard let month = Int(value[4..<6]), month <= 12 else {
            return nil
        }

        guard let day = Int(value[6..<8]), day <= 31 else {
            return nil
        }

        return (year, month, day)
    }
    
    private func dateFrom(year: Int, month: Int, day: Int) -> Date? {
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: year, month: month, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return dateComponents.date
    }

}

struct DateTimeMapper: ValueMapper {
    internal func mapValue(value: String) -> Date {
        return Date()
    }
}


struct ComponentValueType: Equatable {
    static func == (lhs: ComponentValueType, rhs: ComponentValueType) -> Bool {
        return true
    }
}
