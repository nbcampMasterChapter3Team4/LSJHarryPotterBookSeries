//
//  AttributeType+BookInfo.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 4/3/25.
//

import Foundation

// MARK: - AttributeType Enum
 enum BookInfoAttributeType: String {
    case author = "Author"
    case released = "Released"
    case pages = "Pages"
    
    func getTitleFontSize() -> CGFloat {
        switch self {
        case .author:
            return 16
        case .released, .pages:
            return 14
        }
    }
    
    func getValueFontSize() -> CGFloat {
        switch self {
        case .author:
            return 18
        case .released, .pages:
            return 14
        }
    }
}
