//
//  CalendarGenerator.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 1/1/17.
//  Copyright © 2017 Kerem Karatal. All rights reserved.
//

import Foundation

public struct CalendarGenerator {
    private var iCalendar = ICalendar()

    public mutating func generate(rootNode: Node<Component>) -> ICalendar {
        addCalendarMethods(rootNode: rootNode)
        iCalendar.events = addEvents(rootNode: rootNode)
        return iCalendar
    }
    
    private mutating func addCalendarMethods(rootNode: Node<Component>) {
        if let method = rootNode.childNode(name: .method) as? Node<String> {
            iCalendar.method = method.value
        }
        if let version = rootNode.childNode(name: .version) as? Node<String> {
            iCalendar.version = version.value
        }
        if let prodId = rootNode.childNode(name: .prodId) as? Node<String> {
            iCalendar.method = prodId.value
        }
        if let scale = rootNode.childNode(name: .calScale) as? Node<String> {
            var scaleValue: Calendar.Identifier
            switch scale.value {
                case "GREGORIAN":
                scaleValue = .gregorian
                break
                default:
                scaleValue = .gregorian
                break
            }
            iCalendar.scale = scaleValue
        }
    }
    
    private mutating func addEvents(rootNode: Node<Component>) -> [Event] {
        return rootNode.childNodes(type: .container)
            .filter(filterEvents)
            .map(createEvent)
            .filter({ $0 != nil} ) as! [Event]
    }
    
    private func filterEvents(node: TreeNode) -> Bool {
        if let node = node as? Node<Component> {
            return node.value == .event
        } else {
            return false
        }        
    }

    private func createEvent(node: TreeNode) -> Event? {
        if let node = node as? Node<Component> {
            return Event.create(node: node)
        } else {
            return nil
        }
    }
}
