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
        let durationString = "P1DT12H5M"
        let expectedDuration = Duration(isNegative: false, days: 1, weeks: nil, hours: 12, minutes: 5, seconds: nil)
        let duration = DurationMapper().mapValue(value: durationString).flatMap()
        
        XCTAssert(duration == expectedDuration)
    }
    
    func testNegativeDuration() {
        let durationString = "-P1DT12H5S"
        let expectedDuration = Duration(isNegative: true, days: 1, weeks: nil, hours: 12, minutes: nil, seconds: 5)
        let duration = DurationMapper().mapValue(value: durationString).flatMap()
        
        XCTAssert(duration == expectedDuration)
    }
    
    func testIncorrectInputs() {
        
    }
}
