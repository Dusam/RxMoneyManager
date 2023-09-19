//
//  TransferGroup.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum TransferGroup: Int, CaseIterable {
    case transferMoney = 0 
    
    var name: String {
        switch self {
        case .transferMoney:
            return "轉帳"
        }
    }
}
