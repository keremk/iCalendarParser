//
//  PeriodOfTimeMapper.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/26/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct PeriodofTimeMapper: ValueMapper {

    // https://icalendar.org/iCalendar-RFC-5545/3-3-9-period-of-time.html
    internal func mapValue(value: String) -> Result<PeriodOfTime, RuleError> {
        let periodComponents = value.components(separatedBy: "/")
        guard (periodComponents.count == 2) else {
            return .failure(RuleError.UnexpectedValue)
        }
    
        let startDateResult = DateTimeMapper().mapValue(value: periodComponents[0])
        guard case .success(let startDate) = startDateResult else {
            return .failure(RuleError.UnexpectedValue)
        }
        
        let endDateOrDurationString = periodComponents[1]
        if (endDateOrDurationString[endDateOrDurationString.startIndex] == "P") {
            let durationResult = DurationMapper().mapValue(value: endDateOrDurationString)
            if case .success(let duration) = durationResult {
                return .success(PeriodOfTime(start: startDate, period: .duration(duration)))
            } else {
                return .failure(RuleError.UnexpectedValue)
            }
        } else {
            let endDateResult = DateTimeMapper().mapValue(value: endDateOrDurationString)
            if case .success(let endDate) = endDateResult {
                return .success(PeriodOfTime(start: startDate, period: .endDate(endDate)))
            } else {
                return .failure(RuleError.UnexpectedValue)
            }
            
        }
    }
}
