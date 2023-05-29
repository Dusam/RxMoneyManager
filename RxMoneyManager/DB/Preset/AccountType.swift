//
//  AccountType.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/24.
//

import Foundation
import UIKit

enum AccountType: Int, CaseIterable {
    case cash = 0
    case card
    case bank
    
    var typeInt: Int {
        switch self {
        case .cash:
            return 0
        case .card:
            return 1
        case .bank:
            return 2
        }
    }
    
    var typeName: String {
        switch self {
        case .cash:
            return R.string.localizable.cash()
        case .card:
            return R.string.localizable.creditCard()
        case .bank:
            return R.string.localizable.bank()
        }
    }
    
    var image: UIImage {
        switch self {
        case .cash:
            return UIImage(systemName: "creditcard.fill")!
        case .card:
            return UIImage(systemName: "creditcard.fill")!
        case .bank:
            return UIImage(systemName: "creditcard.fill")!
        }
    }
}
