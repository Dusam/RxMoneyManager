//
//  ExpensesOther.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesOther: Int, CaseIterable {
    case pet = 0 
    case donation
    case miscellaneous
    
    var name: String {
        switch self {
        case .pet:
            return "寵物"
        case .donation:
            return "慈善捐款"
        case .miscellaneous:
            return "雜支"
        }
    }
    
}
