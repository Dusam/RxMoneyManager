//
//  ExpensesBook.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesBook: Int, CaseIterable {
    case book = 0
    case newspaper
    case magazine
    case comics
    
    var name: String {
        switch self {
        case .book:
            return "書籍"
        case .newspaper:
            return "報紙"
        case .magazine:
            return "雜誌"
        case .comics:
            return "漫畫"
        }
    }
    
}
