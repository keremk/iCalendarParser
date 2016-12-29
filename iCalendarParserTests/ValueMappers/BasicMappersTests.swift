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
    
    func testFloatMapper() {
        let result = FloatMapper().mapValue(value: "3.3")
        assertValue(result: result, expectedValue: 3.3)
    }
    
    func testFloatMapperWithIncorrectValue() {
        let result = FloatMapper().mapValue(value: "GOBBLE GOBBLE")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testIntegerMapper() {
        let result = IntegerMapper().mapValue(value: "3")
        assertValue(result: result, expectedValue: 3)
    }
    
    func testIntegerMapperWithIncorrectValue() {
        let result = IntegerMapper().mapValue(value: "GOBBLE GOBBLE")
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testUriMapper() {
        let result = UriMapper().mapValue(value: "http://www.ietf.org/rfc/rfc2396.txt")
        assertValue(result: result, expectedValue: URL(string: "http://www.ietf.org/rfc/rfc2396.txt")!)
    }
    
    func testUriMapperWithIncorrectValue() {
        // URL class in foundation seems to always succeed.
//        let result = UriMapper().mapValue(value: "Vd:se")
//        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testCalendarUserAddressMapper() {
        let result = CalendarUserAddressMapper().mapValue(value: "mailto:jane_doe@example.com")
        assertValue(result: result, expectedValue: URL(string: "mailto:jane_doe@example.com")!)
    }
}
