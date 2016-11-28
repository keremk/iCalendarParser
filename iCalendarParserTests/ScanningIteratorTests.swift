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
        XCTAssert(value.current == "A".utf8.first)
        XCTAssert(value.preceding == nil)
        XCTAssert(value.next == "B".utf8.first)
    }
    
    func testBoundaryCases() {
        let input = "AB"
        var iterator = ScanningSequence(input: input).makeIterator()
        
        let (_, _) = iterator.next()!
        let (_, _) = iterator.next()!
        let value = iterator.next()
        
        XCTAssertNil(value)
    }

    func testForLoop() {
        let input = "ABC"
        let sequence = ScanningSequence(input: input)
        let expectedSequence = [(0, ScannedUTF8(preceding: nil, current: "A".utf8.first, next: "B".utf8.first)),
                                (1, ScannedUTF8(preceding: "A".utf8.first, current: "B".utf8.first, next: "C".utf8.first)),
                                (2, ScannedUTF8(preceding: "B".utf8.first, current: "C".utf8.first, next: nil))]
        
        for (index, value) in sequence {
            XCTAssert(index == expectedSequence[index].0)
            XCTAssert(value == expectedSequence[index].1)
        }
    }
}
