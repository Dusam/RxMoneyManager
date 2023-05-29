//
//  TransferGeneral.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum TransferGeneral: Int, CaseIterable {
    case general = 0 
    
    var name: String {
        switch self {
        case .general:
            return "一般轉帳"
        }
    }
}
