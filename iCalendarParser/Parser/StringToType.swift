//
//  StringToType.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/18/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

extension String {
    func toBool() -> Bool {
        var value: Bool
        switch self {
        case "true", "TRUE":
        value = true
        case "false", "FALSE":
        value = false
        default:
            value = false
        }
        return value
    }
}
