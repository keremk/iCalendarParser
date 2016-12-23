//
//  BasicMappersTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class BasicMappersTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
}
