//
//  ExpensesType.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesClothing: Int, CaseIterable {
    case jacket = 0
    case pants
    case coat
    case shoes
    case bag
    case accessories
    case haircut
    case skincare
    
    var name: String {
        switch self {
        case .jacket:
            return "上衣"
        case .pants:
            return "褲子"
        case .coat:
            return "外套"
        case .shoes:
            return "鞋子"
        case .bag:
            return "包包"
        case .accessories:
            return "配件"
        case .haircut:
            return "剪髮理容"
        case .skincare:
            return "保養品"
        }
    }
}
