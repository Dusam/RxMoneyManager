//
//  ExpensesElectronicProduct.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesElectronicProduct: Int, CaseIterable {
    case cellPhone = 0
    case camera
    case earphone
    case computer
    
    var name: String {
        switch self {
        case .cellPhone:
            return "手機"
        case .camera:
            return "相機"
        case .earphone:
            return "耳機"
        case .computer:
            return "電腦商品"
        }
    }
    
}
