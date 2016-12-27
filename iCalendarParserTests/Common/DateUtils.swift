//
//  DateUtils.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/27/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

func dateFrom(year: Int? = nil, month: Int? = nil, day: Int? = nil,
              hour: Int? = nil, minute: Int? = nil, second: Int? = nil,
              timeZone: TimeZone = TimeZone.current) -> Date {
    let dateComponents = DateComponents(calendar: Calendar.current, timeZone: timeZone, era: nil,
                                        year: year, month: month, day: day,
                                        hour: hour, minute: minute, second: second,
                                        nanosecond: nil, weekday: nil, weekdayOrdinal: nil,
                                        quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    return dateComponents.date!
}
