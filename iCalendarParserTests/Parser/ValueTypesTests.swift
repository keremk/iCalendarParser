//
//  ValueTypesTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/18/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ValueTypesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func dateFrom(year: Int, month: Int, day: Int) -> Date {
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: year, month: month, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return dateComponents.date!
    }
    
    func assertFailure<T>(value: ValueResult<T>, expectedError: RuleError) {
        switch value {
        case .value(_):
            XCTFail("Not expecting a value")
        case .error(let error):
            XCTAssert(error == expectedError)
        }
    }
    
    func testBooleanMapper() {
        var boolString = "TRUE"
        var boolValue = BooleanMapper().mapValue(value: boolString).flatMap()!
        XCTAssert(boolValue == true)
        
        boolString = "FALSE"
        boolValue = BooleanMapper().mapValue(value: boolString).flatMap()!
        XCTAssert(boolValue == false)
    }
    
    func testBooleanMapperWithIncorrectValue() {
        let boolString = "GOBBLEDYGOOK"
        let boolValue = BooleanMapper().mapValue(value: boolString)
        
        assertFailure(value: boolValue, expectedError: RuleError.UnexpectedValue)
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

}
