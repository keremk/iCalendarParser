//
//  ValueTypes.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/11/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct ComponentValueType: Comparable {
    static func == (lhs: ComponentValueType, rhs: ComponentValueType) -> Bool {
        return true
    }
    
    static func < (lhs: ComponentValueType, rhs: ComponentValueType) -> Bool {
        return true
    }
}
