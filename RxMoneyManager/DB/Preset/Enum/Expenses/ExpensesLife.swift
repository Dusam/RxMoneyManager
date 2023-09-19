//
//  ExpensesLife.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesLife: Int, CaseIterable {
    case furniture = 0
    case homeAppliances
    case rent
    case managementFee
    case waterBill
    case electricityBill
    case GasFee
    case television
    case internetFee
    case telephoneFee
    
    var name: String {
        switch self {
        case .furniture:
            return "傢俱"
        case .homeAppliances:
            return "家電用品"
        case .rent:
            return "房租"
        case .managementFee:
            return "管理費"
        case .waterBill:
            return "水費"
        case .electricityBill:
            return "電費"
        case .GasFee:
            return "瓦斯費"
        case .television:
            return "有線電視費"
        case .internetFee:
            return "網路費"
        case .telephoneFee:
            return "電話費"
        }
    }
}
