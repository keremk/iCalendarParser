//
//  ScanningIterator.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 11/20/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct ScannedUTF8 {
    let preceding:UTF8.CodeUnit?
    let current:UTF8.CodeUnit?
    let next: UTF8.CodeUnit?
}

extension ScannedUTF8 {
    public static func ==(lhs: ScannedUTF8, rhs: ScannedUTF8) -> Bool {
        return ((lhs.current == rhs.current) && (lhs.next == rhs.next) && (lhs.preceding == rhs.preceding))
    }
}

struct ScanningIterator : IteratorProtocol {
    let input: String
    var iterator: EnumeratedIterator<String.UTF8View.Iterator>
    var precedingValue: (Int, UTF8.CodeUnit)?
    var currentValue: (Int, UTF8.CodeUnit)?
    var nextValue: (Int, UTF8.CodeUnit)?
    var index = -1
    
    init(input: String) {
        self.input = input
        self.iterator = input.utf8.enumerated().makeIterator()
    }
    
    public mutating func next() -> (Int, ScannedUTF8)? {
        index += 1

        if index == 0 {
            currentValue = iterator.next()
            nextValue = iterator.next()
        } else {
            precedingValue = currentValue
            currentValue = nextValue
            nextValue = iterator.next()
        }
        
        if (currentValue == nil) {
            return nil
        } else {
            return (index, ScannedUTF8(preceding: precedingValue?.1, current: currentValue?.1, next: nextValue?.1))
        }        
    }
}

struct ScanningSequence : Sequence {
    let input: String
    
    func makeIterator() -> ScanningIterator {
        return ScanningIterator(input: input)
    }
}
