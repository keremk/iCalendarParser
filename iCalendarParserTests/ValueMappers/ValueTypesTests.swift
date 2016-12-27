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
    
    func testPeriodOfTime() {
        let startDate = dateFrom(year: 1994, month: 10, day: 8)
        let startDate2 = dateFrom(year: 1994, month: 1, day: 1)
        let endDate = dateFrom(year: 1994, month: 11, day: 1)
        let duration = Duration(isNegative: false, days: 10)
        let periodOfTime1 = PeriodOfTime(start: startDate, period: .endDate(endDate))
        let periodOfTime2 = PeriodOfTime(start: startDate, period: .duration(duration))
        let periodOfTime3 = PeriodOfTime(start: startDate2, period: .endDate(endDate))
        let periodOfTime4 = PeriodOfTime(start: startDate, period: .endDate(endDate))
        let periodOfTime5 = PeriodOfTime(start: startDate, period: .duration(duration))
        
        XCTAssert(periodOfTime1 != periodOfTime2)
        XCTAssert(periodOfTime1 != periodOfTime3)
        XCTAssert(periodOfTime1 == periodOfTime4)
        XCTAssert(periodOfTime2 == periodOfTime5)
    }
    
}
