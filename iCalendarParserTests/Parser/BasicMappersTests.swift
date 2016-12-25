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
        var result = BooleanMapper().mapValue(value: "TRUE")
        assertValue(result: result, expectedValue: true)
        
        result = BooleanMapper().mapValue(value: "FALSE")
        assertValue(result: result, expectedValue: false)
    }
    
    func testBooleanMapperWithIncorrectValue() {
        let result = BooleanMapper().mapValue(value: "GOBBLEDYGOOK")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
}
