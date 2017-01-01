//
//  SimpleTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/31/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class SimpleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleiCalFile() {
        let input = readFile(filename: "simple")!
        
        let node = Parser().parse(input: input) as! Node<Component>
        XCTAssert(node.name == .begin)
        XCTAssert(node.value == .calendar)
        
        let events = node.childNodes(type: .container)
        XCTAssert(events.count == 1)
        let event = events[0] as! Node<Component>
        XCTAssert(event.value == .event)
    }
}
