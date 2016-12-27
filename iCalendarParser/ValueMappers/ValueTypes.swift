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


struct ComponentValueType: Equatable {
    static func == (lhs: ComponentValueType, rhs: ComponentValueType) -> Bool {
        return true
    }
}

struct Duration: Equatable {
    var isNegative:Bool // Used for alarms
    var dateComponents: DateComponents = DateComponents()
    var days: Int? {
        get {
            return dateComponents.day
        }
        set(newValue) {
            dateComponents.day = newValue
        }
    }
    var weeks: Int? {
        get {
            return dateComponents.weekOfYear
        }
        set(newValue) {
            dateComponents.weekOfYear = newValue
        }
    }
    var hours: Int? {
        get {
            return dateComponents.hour
        }
        set(newValue) {
            dateComponents.hour = newValue
        }
    }
    var minutes: Int? {
        get {
            return dateComponents.minute
        }
        set(newValue) {
            dateComponents.minute = newValue
        }
    }
    var seconds: Int? {
        get {
            return dateComponents.second
        }
        set(newValue) {
            dateComponents.second = newValue
        }
    }
    
    init() {
        self.isNegative = false
    }
    
    init(isNegative: Bool, days: Int?, weeks: Int? = nil, hours: Int? = nil, minutes: Int? = nil, seconds: Int? = nil) {
        self.isNegative = isNegative
        self.days = days
        self.weeks = weeks
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
}

extension Duration {
    // Does not try to equate 24 hours to days etc. Semantically 2 duration values that correspond to the same duration will not be equal unless they are literally equal.
    static func == (lhs: Duration, rhs: Duration) -> Bool {
        if  lhs.isNegative != rhs.isNegative ||
            lhs.dateComponents != rhs.dateComponents {
            return false
        } else {
            return true
        }
    }
}

enum PeriodIndicator {
    case endDate(Date)
    case duration(Duration)
}

extension PeriodIndicator {
    static func == (lhs: PeriodIndicator, rhs: PeriodIndicator) -> Bool {
        switch (lhs, rhs) {
        case (.endDate(let lhsEndDate), .endDate(let rhsEndDate)):
            return lhsEndDate == rhsEndDate
        case (.duration(let lhsDuration), .duration(let rhsDuration)):
            return lhsDuration == rhsDuration
        default:
            return false
        }
    }
    
    static func != (lhs: PeriodIndicator, rhs: PeriodIndicator) -> Bool {
        return !(lhs == rhs)
    }
}

struct PeriodOfTime: Equatable {
    let start: Date
    let period: PeriodIndicator
    
    init(start: Date, period: PeriodIndicator) {
        self.start = start
        self.period = period
    }
}

extension PeriodOfTime {
    static func == (lhs: PeriodOfTime, rhs: PeriodOfTime) -> Bool {
        if lhs.start != rhs.start ||
            lhs.period != rhs.period {
            return false
        } else {
            return true
        }
    }
}
