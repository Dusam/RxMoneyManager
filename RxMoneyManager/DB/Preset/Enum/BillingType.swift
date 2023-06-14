//
//  BillingType.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/26.
//

import Foundation
import SwiftUI

enum BillingType: Int, CaseIterable {
    case spend = 0
    case income
    case transfer
    
    var name: String {
        switch self {
        case .spend:
            return R.string.localizable.spend()
        case .income:
            return R.string.localizable.income()
        case .transfer:
            return R.string.localizable.transfer()
        }
    }
    
    var forgroundColor: UIColor {
        switch self {
        case .spend:
            return R.color.spendColor()!
        case .income:
            return R.color.incomeColor()!
        case .transfer:
            return R.color.transferColor()!
        }
    }
}
