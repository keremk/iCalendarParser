//
//  Stack.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/5/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element? {
        return items.popLast()
    }
    
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
