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
        
        let dateString = "19970714"
        let date = DateMapper().mapValue(value: dateString).flatMap()!
        
        let expectedDate = dateFrom(year: 1997, month: 07, day: 14)
        XCTAssert(date == expectedDate)
    }
    
    func testDateMapperWithIncorrectLength() {
        let dateString = "1997071"
        let date = DateMapper().mapValue(value: dateString)
        
        assertFailure(value: date, expectedError: RuleError.UnexpectedValue)
    }
    
    func testDateMapperWithIncorrectValues() {
        var dateString = "19971412"
        var date = DateMapper().mapValue(value: dateString)
        assertFailure(value: date, expectedError: RuleError.UnexpectedValue)
        
        dateString = "19970734"
        date = DateMapper().mapValue(value: dateString)
        assertFailure(value: date, expectedError: RuleError.UnexpectedValue)
        
        dateString = "199707aa"
        date = DateMapper().mapValue(value: dateString)
        assertFailure(value: date, expectedError: RuleError.UnexpectedValue)
        
        dateString = "1av70712"
        date = DateMapper().mapValue(value: dateString)
        assertFailure(value: date, expectedError: RuleError.UnexpectedValue)
    }
    
    func testDateTimeMapper() {
        // https://icalendar.org/iCalendar-RFC-5545/3-3-4-date.html
        
        var dateTimeString = "19970714T230000"
        var dateTime = DateTimeMapper().mapValue(value: dateTimeString).flatMap()!
        
        var expectedDateTime = dateFrom(year: 1997, month: 07, day: 14, hour: 23, minute: 0, second:0)
        XCTAssert(dateTime == expectedDateTime)
        
        dateTimeString = "19970714T230000Z"
        dateTime = DateTimeMapper().mapValue(value: dateTimeString).flatMap()!
        expectedDateTime = dateFrom(year: 1997, month: 07, day: 14, hour: 23, minute: 0, second:0, timeZone: TimeZone(secondsFromGMT: 0)!)
        
        XCTAssert(dateTime == expectedDateTime)
    }
    
    func testDateTimeMapperMissingT() {
        let dateTimeString = "19970714B230000"
        let dateTime = DateTimeMapper().mapValue(value: dateTimeString)
        assertFailure(value: dateTime, expectedError: RuleError.UnexpectedValue)
    }
    
    func testDateTimeMapperIncorrectLength() {
        let dateTimeString = "19970714T23000"
        let dateTime = DateTimeMapper().mapValue(value: dateTimeString)
        assertFailure(value: dateTime, expectedError: RuleError.UnexpectedValue)
    }
    
    
    func testDateTimeMapperIncorrectValues() {
        var dateTimeString = "19970714T250000"
        var dateTime = DateTimeMapper().mapValue(value: dateTimeString)
        assertFailure(value: dateTime, expectedError: RuleError.UnexpectedValue)
        
        dateTimeString = "19970714T236000"
        dateTime = DateTimeMapper().mapValue(value: dateTimeString)
        assertFailure(value: dateTime, expectedError: RuleError.UnexpectedValue)
        
        dateTimeString = "19970714T230060"
        dateTime = DateTimeMapper().mapValue(value: dateTimeString)
        assertFailure(value: dateTime, expectedError: RuleError.UnexpectedValue)
        
        dateTimeString = "19970714T2300xz"
        dateTime = DateTimeMapper().mapValue(value: dateTimeString)
        assertFailure(value: dateTime, expectedError: RuleError.UnexpectedValue)
    }    
}
