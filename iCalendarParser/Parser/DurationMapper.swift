//
//  PeriodOfTimeMapper.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct DurationMapper: ValueMapper {
    
    // https://icalendar.org/iCalendar-RFC-5545/3-3-6-duration.html
    internal func mapValue(value: String) -> ValueResult<Duration> {
        var durationLexer = DurationLexer(input: value)
        let tokens = durationLexer.scan()

        var duration: Duration = Duration()
        var currentValue:Int = 0
        for token in tokens {
            switch token {
            case Token.minus:
                duration.isNegative = true
                break
            case Token.day:
                duration.days = currentValue
                break
            case Token.week:
                duration.weeks = currentValue
                break
            case Token.hour:
                duration.hours = currentValue
                break
            case Token.minute:
                duration.minutes = currentValue
                break
            case Token.second:
                duration.seconds = currentValue
                break
            case Token.identifier(let identifier):
                currentValue = Int(identifier)!
                break
            default:
                break
            }
        }
        
        return ValueResult<Duration>.value(duration)
    }
}
