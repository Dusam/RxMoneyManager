//
//  IncomeGeneral.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum IncomeGeneral: Int, CaseIterable {
    case other = 0 
    case creditCardRebate
    case Salary
    case DepositInterest
    case pt
    case stock
    case sideJob
   
    var name: String {
        switch self {
        case .other:
            return "其他"
        case .creditCardRebate:
            return "信用卡回饋"
        case .Salary:
            return "公司薪資"
        case .DepositInterest:
            return "存款利息"
        case .pt:
            return "打工"
        case .stock:
            return "股票"
        case .sideJob:
            return "兼差"
        }
    }
    
}
