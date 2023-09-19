//
//  ExpensesEntertainment.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesEntertainment: Int, CaseIterable {
    case movie = 0
    case KTV
    case toy
    case exhibition
    case travel
    case shopping
    case sports
    case game
    case netflix
    
    var name: String {
        switch self {
        case .movie:
            return "電影"
        case .KTV:
            return "KTV"
        case .toy:
            return "玩具"
        case .exhibition:
            return "展覽"
        case .travel:
            return "旅遊"
        case .shopping:
            return "Shopping"
        case .sports:
            return "運動"
        case .game:
            return "遊戲"
        case .netflix:
            return "Netflix"
        }
    }
    
}
