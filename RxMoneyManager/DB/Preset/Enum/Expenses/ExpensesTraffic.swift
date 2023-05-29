//
//  ExpensesTraffic.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesTraffic: Int, CaseIterable {
    case bus = 0
    case MRT
    case taxi
    case HSR
    case airplane
    case lightRail
    case uber
    case train
    case ubike
    
    var name: String {
        switch self {
        case .bus:
            return "公車"
        case .MRT:
            return "捷運"
        case .taxi:
            return "計程車"
        case .HSR:
            return "高鐵"
        case .airplane:
            return "飛機"
        case .lightRail:
            return "輕軌"
        case .uber:
            return "Uber"
        case .train:
            return "火車"
        case .ubike:
            return "Ubike"
        }
    }
}
