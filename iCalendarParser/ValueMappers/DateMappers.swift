//
//  DateMappers.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct DateTimeValues {
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    var second: Int?
    var timeZone = TimeZone.current
}

protocol DateTimeParser {
    func parseDateTime(dateValue: String?, timeValue: String?) -> Date?
}

extension DateTimeParser {
    internal func parseDateTime(dateValue: String?, timeValue: String? = nil) -> Date? {
        var dateTimeValues = DateTimeValues()
        
        var isValid = true
        if let dateValue = dateValue {
            isValid = parseDate(value: dateValue, dateTimeValues: &dateTimeValues)
        }
        
        if let timeValue = timeValue {
            isValid = parseTime(value: timeValue, dateTimeValues: &dateTimeValues)
        }
        
        if isValid {
            return dateFrom(dateTimeValues)
        } else {
            return nil
        }
    }
    
    private func parseDate(value: String, dateTimeValues: inout DateTimeValues) -> Bool {
        guard value.utf8.count == 8 else {
            return false
        }
        
        guard let year = Int(value[0..<4]) else {
            return false
        }
        
        guard let month = Int(value[4..<6]), month <= 12 else {
            return false
        }
        
        guard let day = Int(value[6..<8]), day <= 31 else {
            return false
        }
        dateTimeValues.year = year
        dateTimeValues.month = month
        dateTimeValues.day = day
        return true
    }
    
    private func parseTime(value: String, dateTimeValues: inout DateTimeValues) -> Bool{
        guard value.utf8.count == 6 || value.utf8.count == 7 else {
            return false
        }
        
        guard let hour = Int(value[0..<2]), hour <= 23,
            let minute = Int(value[2..<4]), minute <= 59,
            let second = Int(value[4..<6]), second <= 59 else {
                return false
        }
        
        var timeZone:TimeZone
        let timeZoneIndicator = value.last()
        if timeZoneIndicator == "Z" {
            timeZone = TimeZone(secondsFromGMT: 0)!
        } else {
            timeZone = TimeZone.current
        }
        
        dateTimeValues.hour = hour
        dateTimeValues.minute = minute
        dateTimeValues.second = second
        dateTimeValues.timeZone = timeZone
        return true
    }
    
    private func dateFrom(_ dateTimeValues: DateTimeValues) -> Date? {
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: dateTimeValues.timeZone, era: nil,
                                            year: dateTimeValues.year, month: dateTimeValues.month, day: dateTimeValues.day,
                                            hour: dateTimeValues.hour, minute: dateTimeValues.minute, second: dateTimeValues.second,
                                            nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return dateComponents.date
    }
}

struct DateMapper: ValueMapper, DateTimeParser {
    
    // https://icalendar.org/iCalendar-RFC-5545/3-3-4-date.html
    internal func mapValue(value: String) -> Result<Date, RuleError>  {
        if let date = parseDateTime(dateValue: value) {
            return .success(date)
        } else {
            return .failure(RuleError.UnexpectedValue)
        }
    }
}

struct TimeMapper: ValueMapper, DateTimeParser {
    
    // https://icalendar.org/iCalendar-RFC-5545/3-3-12-time.html
    internal func mapValue(value: String) -> Result<Date, RuleError> {

        if let time = parseDateTime(dateValue: nil, timeValue: value) {
            return .success(time)
        } else {
            return .failure(RuleError.UnexpectedValue)
        }
    }
}

struct DateTimeMapper: ValueMapper, DateTimeParser {
    
    // https://icalendar.org/iCalendar-RFC-5545/3-3-5-date-time.html
    internal func mapValue(value: String) -> Result<Date, RuleError> {
        let dateTimeComponents = value.components(separatedBy: "T")
        guard (dateTimeComponents.count == 2) else {
            return .failure(RuleError.UnexpectedValue)
        }
        let dateString = dateTimeComponents[0]
        let timeString = dateTimeComponents[1]
        
        if let date = parseDateTime(dateValue: dateString, timeValue: timeString) {
            return .success(date)
        } else {
            return .failure(RuleError.UnexpectedValue)
        }        
    }
}

struct UTCOffsetMapper: ValueMapper, DateTimeParser {
    
    // https://icalendar.org/iCalendar-RFC-5545/3-3-14-utc-offset.html
    // Returns in number of seconds to be used in TimeZone(forSecondsFromGMT: seconds)
    internal func mapValue(value: String) -> Result<TimeZone, RuleError> {
        let secondsResult = parseUTCOffset(value: value)
        switch secondsResult {
        case .success(let seconds):
            if let timeZone = TimeZone(secondsFromGMT: seconds) {
                return .success(timeZone)
            } else {
                return .failure(RuleError.UnexpectedValue)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func parseUTCOffset(value: String) -> Result<Int, RuleError>{
        guard value.utf8.count == 5 || value.utf8.count == 7 else {
            return .failure(RuleError.UnexpectedValue)
        }
        
        guard let hour = Int(value[1..<3]), hour <= 23,
            let minute = Int(value[3..<5]), minute <= 59 else {
                return .failure(RuleError.UnexpectedValue)
        }
        
        var sign: Int = 1
        if value.first() == "+" {
            sign = 1
        } else if value.first() == "-" {
            sign = -1
        } else {
            return .failure(RuleError.UnexpectedValue)
        }
        
        var second:Int = 0
        if value.utf8.count == 7,
            let possibleSeconds = Int(value[5..<7]),
            possibleSeconds <= 59 {
            second = possibleSeconds
        }
        
        return .success(sign * (hour * 360 + minute * 60 + second))
    }

}
