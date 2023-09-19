//
//  ExpensesPersonalCommunication.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesPersonalCommunication: Int, CaseIterable {
    case giftsAndTreats = 0
    case socialize
    case weddingAndFuneral
    case filialPietyParents
    case redEnvelope
    
    var name: String {
        switch self {
        case .giftsAndTreats:
            return "送禮請客"
        case .socialize:
            return "交際應酬"
        case .weddingAndFuneral:
            return "婚喪喜慶"
        case .filialPietyParents:
            return "孝養父母"
        case .redEnvelope:
            return "紅包"
        }
    }
    
}
