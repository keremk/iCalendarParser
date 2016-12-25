//
//  DateMappersTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class DateMappersTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func dateFrom(year: Int, month: Int, day: Int, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, timeZone: TimeZone = TimeZone.current) -> Date {
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: timeZone, era: nil,
                                            year: year, month: month, day: day,
                                            hour: hour, minute: minute, second: second,
                                            nanosecond: nil, weekday: nil, weekdayOrdinal: nil,
                                            quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return dateComponents.date!
    }

    func testDateMapper() {
        // https://icalendar.org/iCalendar-RFC-5545/3-3-4-date.html
        
        let result = DateMapper().mapValue(value: "19970714")
        let expectedDate = dateFrom(year: 1997, month: 07, day: 14)
        assertValue(result: result, expectedValue: expectedDate)
    }
    
    func testDateMapperWithIncorrectLength() {
        let result = DateMapper().mapValue(value: "1997071")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testDateMapperWithIncorrectValues() {
        var result = DateMapper().mapValue(value: "19971412")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
        
        result = DateMapper().mapValue(value: "19970734")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
        
        result = DateMapper().mapValue(value: "199707aa")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
        
        result = DateMapper().mapValue(value: "1av70712")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testDateTimeMapper() {
        // https://icalendar.org/iCalendar-RFC-5545/3-3-4-date.html
        
        var result = DateTimeMapper().mapValue(value: "19970714T230000")
        var expectedDateTime = dateFrom(year: 1997, month: 07, day: 14, hour: 23, minute: 0, second:0)
        assertValue(result: result, expectedValue: expectedDateTime)
        
        result = DateTimeMapper().mapValue(value: "19970714T230000Z")
        expectedDateTime = dateFrom(year: 1997, month: 07, day: 14, hour: 23, minute: 0, second:0, timeZone: TimeZone(secondsFromGMT: 0)!)
        assertValue(result: result, expectedValue: expectedDateTime)        
    }
    
    func testDateTimeMapperMissingT() {
        let result = DateTimeMapper().mapValue(value: "19970714B230000")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testDateTimeMapperIncorrectLength() {
        let result = DateTimeMapper().mapValue(value: "19970714T23000")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    
    func testDateTimeMapperIncorrectValues() {
        var result = DateTimeMapper().mapValue(value: "19970714T250000")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
        
        result = DateTimeMapper().mapValue(value: "19970714T236000")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
        
        result = DateTimeMapper().mapValue(value: "19970714T230060")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
        
        result = DateTimeMapper().mapValue(value: "19970714T2300xz")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }    
}
