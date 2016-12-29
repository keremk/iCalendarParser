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
    
    func testDateMapper() {
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
    
    func testTimeMapper() {
        var result = TimeMapper().mapValue(value: "230000")
        var expectedTime = dateFrom(year: nil, month: nil, day: nil, hour: 23, minute: 0, second: 0)
        assertValue(result: result, expectedValue: expectedTime)
        
        result = TimeMapper().mapValue(value: "230000Z")
        expectedTime = dateFrom(year: nil, month: nil, day: nil, hour: 23, minute: 0, second: 0, timeZone: TimeZone(secondsFromGMT: 0)!)
        assertValue(result: result, expectedValue: expectedTime)
    }
    
    func testDateTimeMapper() {
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
    
    func testUTCOffsetMapper() {
        var result = UTCOffsetMapper().mapValue(value: "+0200")
        var expected = TimeZone(secondsFromGMT: 2*360)!
        assertValue(result: result, expectedValue: expected)
        
        result = UTCOffsetMapper().mapValue(value: "-0530")
        expected = TimeZone(secondsFromGMT: -1*(5*360+30*60))!
        assertValue(result: result, expectedValue: expected)
        
        result = UTCOffsetMapper().mapValue(value: "-053010")
        expected = TimeZone(secondsFromGMT: -1*(5*360+30*60+10))!
        assertValue(result: result, expectedValue: expected)
    }
    
    func testUTCOffsetMapperIncorrectLength() {
        let result = UTCOffsetMapper().mapValue(value: "0200")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testUTCOffsetMapperIncorrectValues() {
        var result = UTCOffsetMapper().mapValue(value: "10200")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
        
        result = UTCOffsetMapper().mapValue(value: "+0260")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)

        result = UTCOffsetMapper().mapValue(value: "+0260ab")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)

        result = UTCOffsetMapper().mapValue(value: "+a000")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
}
