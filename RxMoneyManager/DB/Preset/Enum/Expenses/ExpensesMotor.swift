//
//  ExpensesMotor.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesMotor: Int, CaseIterable {
    case oilMoney = 0
    case parkingFee
    case tolls
    case maintenance
    case carWash
    case fuelCost
    case insurance
    case fine
    case licenseTax
    
    var name: String {
        switch self {
        case .oilMoney:
            return "油錢"
        case .parkingFee:
            return "停車費"
        case .tolls:
            return "過路費"
        case .maintenance:
            return "維修保養"
        case .carWash:
            return "美容洗車"
        case .fuelCost:
            return "燃料費"
        case .insurance:
            return "保險與稅捐"
        case .fine:
            return "罰單"
        case .licenseTax:
            return "牌照稅"
        }
    }
    
}
