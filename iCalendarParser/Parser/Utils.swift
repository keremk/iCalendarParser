//
//  StringToType.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/18/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return self.substring(with: startIndex..<endIndex)
        }
    }
}
