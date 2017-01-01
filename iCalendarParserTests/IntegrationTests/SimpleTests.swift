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
    
    func testGenerateAST() {
        let input = readFile(filename: "simple")!
        let parser = Parser()
        let node = parser.generateAST(input: input) as! Node<Component>
        XCTAssert(node.name == .begin)
        XCTAssert(node.value == .calendar)
        
        let events = node.childNodes(type: .container)
        XCTAssert(events.count == 1)
        let event = events[0] as! Node<Component>
        XCTAssert(event.value == .event)
    }
    
    func testGenerateCalendar() {
        let input = readFile(filename: "simple")!
        let parser = Parser()
        if let calendar = parser.parse(input: input) {
            XCTAssert(calendar.version == "2.0")
            XCTAssert(calendar.events.count == 1)
            
            let events = calendar.events
            XCTAssert(events[0].summary?.value == "Networld+Interop Conference")
            XCTAssert(events[0].description?.value == "Networld+Interop Conferenceand Exhibit\\nAtlanta World Congress Center\\nAtlanta\\, Georgia")
        } else {
            XCTFail("No calendar parsed")
        }
    }
}
