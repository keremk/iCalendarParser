//
//  PeriodOfTimeMapperTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/26/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class PeriodOfTimeMapperTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

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
    
    func testWithStartEndDates() {
        let startDate = dateFrom(year: 1997, month: 1, day: 1, hour: 18, minute: 0, second: 0, timeZone: TimeZone(secondsFromGMT: 0)!)
        let endDate = dateFrom(year: 1997, month: 1, day: 2, hour: 7, minute: 0, second: 0, timeZone: TimeZone(secondsFromGMT: 0)!)

        let expectedValue = PeriodOfTime(start: startDate, period: .endDate(endDate))
        let result = PeriodofTimeMapper().mapValue(value: "19970101T180000Z/19970102T070000Z")
        assertValue(result: result, expectedValue: expectedValue)
    }
    
    func testWithStartDateAndDuration() {
        let startDate = dateFrom(year: 1997, month: 1, day: 1, hour: 18, minute: 0, second: 0, timeZone: TimeZone(secondsFromGMT: 0)!)
        let duration = Duration(isNegative: false, days: nil, weeks: nil, hours: 5, minutes: 30, seconds: nil)
        
        let expectedValue = PeriodOfTime(start: startDate, period: .duration(duration))
        let result = PeriodofTimeMapper().mapValue(value: "19970101T180000Z/PT5H30M")
        assertValue(result: result, expectedValue: expectedValue)
    }
    
    func testWithInvalidData() {
        var result = PeriodofTimeMapper().mapValue(value: "/")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)

        result = PeriodofTimeMapper().mapValue(value: "1997/P2D")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)

        result = PeriodofTimeMapper().mapValue(value: "19970101T180000Z/2D")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
}
