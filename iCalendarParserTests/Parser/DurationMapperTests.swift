//
//  PeriodOfTimeMapperTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
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
    
    func testDuration() {
        let expectedDuration = Duration(isNegative: false, days: 1, weeks: nil, hours: 12, minutes: 5, seconds: nil)
        let result = DurationMapper().mapValue(value: "P1DT12H5M")
        assertValue(result: result, expectedValue: expectedDuration)
    }
    
    func testNegativeDuration() {
        let expectedDuration = Duration(isNegative: true, days: 1, weeks: nil, hours: 12, minutes: nil, seconds: 5)
        let result = DurationMapper().mapValue(value: "-P1DT12H5S")
        assertValue(result: result, expectedValue: expectedDuration)
    }
    
    func testIncorrectInputs() {
        let result = DurationMapper().mapValue(value: "-PaDT12H5S")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
}
