//
//  ExpensesGroupType.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/24.
//

import Foundation

enum IncomeGroup: Int, CaseIterable {
    case general = 0
    case investment
    
    var name: String {
        switch self {
        case .general:
            return "一般收入"
        case .investment:
            return "投資收入"
        }
    }
    
}
