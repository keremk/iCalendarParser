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

public struct Event {
    var dateStamp: Date
    var uid: String
    var description: Text?
    var comment: Text?
    var summary: Text?
    
    static func create(node: Node<Component>) -> Event? {
        guard let dateStampNode = node.childNode(name: .dtStamp) as? Node<Date> else {
            return nil
        }
        guard let uid = node.childNode(name: .uid) as? Node<String> else {
            return nil
        }
        var event = Event(dateStamp: dateStampNode.value, uid: uid.value)
        event.description = Text.create(node: node.childNode(name: .description))
        event.comment = Text.create(node: node.childNode(name: .comment))
        event.summary = Text.create(node: node.childNode(name: .summary))
        return event
    }
    
    init(dateStamp: Date, uid: String) {
        self.dateStamp = dateStamp
        self.uid = uid
    }
}

public struct CalendarDescription {
    var version: String? = nil
    var scale: Calendar.Identifier? = nil
    var prodId: String? = nil
    var method: String? = nil
    var events: [Event] = []
}
