//
//  RulesTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class RulesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExistingRule() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        
        let rules = Rules()
        let node = rules.invokeRule(tokens: inputTokens) as! Node<String>
        XCTAssertNotNil(node)
        XCTAssert(node.name == "BEGIN")
        XCTAssert(node.value == "VCALENDAR")
    }
    
    func testFailingBEGINRules() {
        let rules = Rules()

        var inputTokens = [Token.identifier("BEGIN"), Token.parameterSeparator, Token.identifier("VCALENDAR")]
        var node:Any? = rules.invokeRule(tokens: inputTokens)
        XCTAssertNil(node)
        
        inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.valueSeparator]
        node = rules.invokeRule(tokens: inputTokens)
        XCTAssertNil(node)
        
        inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator]
        node = rules.invokeRule(tokens: inputTokens)
        XCTAssertNil(node)
    }
}
