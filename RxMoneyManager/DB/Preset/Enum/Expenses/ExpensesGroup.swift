//
//  ExpensesGroupType.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/24.
//

import Foundation

enum ExpensesGroup: Int, CaseIterable {
    case food = 0
    case clothing
    case life
    case traffic
    case educate
    case entertainment
    case electronicProduct
    case book
    case motor
    case medical
    case personalCommunication
    case invest
    case other
    case fee
    
    var name: String {
        switch self {
        case .food:
            return "餐飲食品"
        case .clothing:
            return "服飾美容"
        case .life:
            return "居家生活"
        case .traffic:
            return "交通"
        case .educate:
            return "教育"
        case .entertainment:
            return "休閒娛樂"
        case .electronicProduct:
            return "通訊產品"
        case .book:
            return "圖書刊物"
        case .motor:
            return "汽機車"
        case .medical:
            return "醫療保健"
        case .personalCommunication:
            return "人情交際"
        case .invest:
            return "理財投資"
        case .other:
            return "其他"
        case .fee:
            return "費用"
        }
    }
    
}
