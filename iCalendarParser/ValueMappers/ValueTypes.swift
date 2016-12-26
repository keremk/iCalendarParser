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
    var isNegative:Bool = false
    var days: Int?
    var weeks: Int?
    var hours: Int?
    var minutes: Int?
    var seconds: Int?
}

extension Duration {
    static func == (lhs: Duration, rhs: Duration) -> Bool {
        return true
    }
}
