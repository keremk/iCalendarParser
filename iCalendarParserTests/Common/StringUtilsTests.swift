//
//  UtilsTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/19/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class UtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringSubscript() {
        let input = "12345"
        var substring = input[0..<3]
        XCTAssert(substring == "123")
        
        substring = input[1..<3]
        XCTAssert(substring == "23")
    }
    
    func testFirst() {
        let input = "12345"
        let first = input.first()
        XCTAssert(first == "1")
    }
    
    func testLast() {
        let input = "12345"
        let last = input.last()
        XCTAssert(last == "5")
    }
}
