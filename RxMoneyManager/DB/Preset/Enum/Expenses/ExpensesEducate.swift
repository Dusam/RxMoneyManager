//
//  ExpensesEducate.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesEducate: Int, CaseIterable {
    case stationery = 0
    case tutoring
    case tuitionFees
    case schoolLoan
    
    var name: String {
        switch self {
        case .stationery:
            return "文具"
        case .tutoring:
            return "補習費"
        case .tuitionFees:
            return "學雜費"
        case .schoolLoan:
            return "就學貸款"
        }
    }
    
}
