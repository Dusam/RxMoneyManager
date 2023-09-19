//
//  ExpensesType.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesFood: Int, CaseIterable {
    case breakfast = 0
    case lunch
    case dinner
    case nightSnack
    case dessert
    case fruit
    case ingredients
    
    var name: String {
        switch self {
        case .breakfast:
            return "早餐"
        case .lunch:
            return "午餐"
        case .dinner:
            return "晚餐"
        case .nightSnack:
            return "宵夜"
        case .dessert:
            return "點心"
        case .fruit:
            return "水果"
        case .ingredients:
            return "食材"
        }
    }
}
