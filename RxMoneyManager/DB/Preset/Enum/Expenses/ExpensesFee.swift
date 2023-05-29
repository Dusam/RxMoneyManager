//
//  ExpensesFee.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesFee: Int, CaseIterable {
    case transfer = 0
    
    var name: String {
        switch self {
        case .transfer:
            return "轉帳費用"
        }
    }
}
