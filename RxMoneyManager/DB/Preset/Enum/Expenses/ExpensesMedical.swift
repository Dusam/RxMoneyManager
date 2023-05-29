//
//  ExpensesMedical.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/25.
//

import Foundation

enum ExpensesMedical: Int, CaseIterable {
    case clinic = 0
    case drug
    case healthExamination
    case laborHealthInsurancePremium
    
    var name: String {
        switch self {
        case .clinic:
            return "診所就醫"
        case .drug:
            return "購買藥物"
        case .healthExamination:
            return "健康檢查"
        case .laborHealthInsurancePremium:
            return "勞健保費"
        }
    }
    
}
