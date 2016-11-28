//
//  ScanningIterator.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 11/20/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct ScanningIterator : IteratorProtocol {
    let input: String
    var iterator: EnumeratedIterator<String.UTF8View.Iterator>
    var precedingValue: (Int, UTF8.CodeUnit)?
    var currentValue: (Int, UTF8.CodeUnit)?

    
    init(input: String) {
        self.input = input
        self.iterator = input.utf8.enumerated().makeIterator()
    }
    
    public mutating func next() -> (Int, UTF8.CodeUnit)? {
        if currentValue != nil {
            precedingValue = currentValue
            currentValue = iterator.next()
        } else {
            currentValue = iterator.next()
            precedingValue = currentValue
        }
        return currentValue
    }

    public func peekPreceeding() -> (Int, UTF8.CodeUnit)? {
        return precedingValue
    }
    
    public func peekFollowing() -> (Int, UTF8.CodeUnit)? {
        var copiedIterator = iterator
        
        return copiedIterator.next()
    }
}

struct ScanningSequence : Sequence {
    let input: String
    
    func makeIterator() -> ScanningIterator {
        return ScanningIterator(input: input)
    }
}
