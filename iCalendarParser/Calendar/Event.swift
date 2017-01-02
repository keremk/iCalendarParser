//
//  Event.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 1/2/17.
//  Copyright © 2017 Kerem Karatal. All rights reserved.
//

import Foundation

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
