//
//  CalendarDescription.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 1/1/17.
//  Copyright © 2017 Kerem Karatal. All rights reserved.
//

import Foundation

public struct Text {
    let value: String
    var altRep: String? = nil
    var language: String? = nil
    
    static func create(node: TreeNode?) -> Text? {
        guard let node = node as? Node<String> else {
            return nil
        }
        var text = Text(node.value)
        if let altRepNode = node.childNode(name: .altRep) as? Node<String> {
            text.altRep = altRepNode.value
        }
        if let language = node.childNode(name: .language) as? Node<String> {
            text.language = language.value
        }
        return text
    }
    
    init(_ value: String) {
        self.value = value
    }
}


public struct ICalendar {
    var version: String? = nil
    var scale: Calendar.Identifier? = nil
    var prodId: String? = nil
    var method: String? = nil
    var events: [Event] = []
}
