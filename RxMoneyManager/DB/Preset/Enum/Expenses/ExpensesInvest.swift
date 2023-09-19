//
//  ExpensesInvest.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesInvest: Int, CaseIterable {
    case fixedDeposit = 0
    case stock
    case futures
    case fund
    
    var name: String {
        switch self {
        case .fixedDeposit:
            return "定存"
        case .stock:
            return "股票"
        case .futures:
            return "期貨"
        case .fund:
            return "基金"
        }
    }
    
}
