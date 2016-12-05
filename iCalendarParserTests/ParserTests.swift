//
//  ParserTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
    func testEmptyCalendar() {
        // BEGIN:VCALENDAR
        // VERSION:2.0
        // END:VCALENDAR
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR"), Token.contentLine, Token.identifier("VERSION"), Token.valueSeparator, Token.identifier("2.0"), Token.contentLine, Token.identifier("END"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        
        var parser = Parser()
        let resultNode = try! parser.parse(tokens: inputTokens) as! Node<String>
        
        XCTAssert(resultNode.name == "BEGIN")
        XCTAssert(resultNode.value == "VCALENDAR")
    }
}
