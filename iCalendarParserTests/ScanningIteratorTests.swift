//
//  ScanningIteratorTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 11/27/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ScanningIteratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleIteration() {
        let input = "AB"
        var iterator = ScanningSequence(input: input).makeIterator()
        
        let (_, value) = iterator.next()!
        XCTAssert(value == "A".utf8.first)
    }
    
    func testPeekPreceeding() {
        let input = "ABC"
        var iterator = ScanningSequence(input: input).makeIterator()
        
        let (_, _) = iterator.next()!
        let (_, value) = iterator.next()!
        XCTAssert(value == "B".utf8.first)
        
        let (_, priorValue) = iterator.peekPreceeding()!
        XCTAssert(priorValue == "A".utf8.first)
    }
    
    func testPeekFollowing() {
        let input = "ABC"
        var iterator = ScanningSequence(input: input).makeIterator()
        
        let (_, _) = iterator.next()!
        let (_, followingValue) = iterator.peekFollowing()!
        XCTAssert(followingValue == "B".utf8.first)
        let (_, value) = iterator.next()!
        XCTAssert(value == "B".utf8.first)
    }
    
    func testBoundaryCases() {
        let input = "AB"
        var iterator = ScanningSequence(input: input).makeIterator()
        
        let preceedingValue = iterator.peekPreceeding()
        XCTAssert(preceedingValue == nil)
        
        let (_, _) = iterator.next()!
        let (_, _) = iterator.next()!
        
        let followingValue = iterator.peekFollowing()
        XCTAssert(followingValue == nil)
        
        let value = iterator.next()
        XCTAssert(value == nil)
    }
    
    func testForLoop() {
        let input = "AB"
        let sequence = ScanningSequence(input: input)
        
        for (index, value) in sequence {
            if (index == 0) {
                XCTAssert(value == "A".utf8.first)
            } else if (index == 1) {
                XCTAssert(value == "B".utf8.first)
            }
        }
    }
}
