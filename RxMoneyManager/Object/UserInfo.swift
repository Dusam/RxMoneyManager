//
//  UserInfo.swift
//  MoneyManager
//
//  Created by Qian-Yu Du on 2022/6/1.
//

import Foundation
import RealmSwift
import SwiftUI

class UserInfo {
    static let share = UserInfo()
    
    let ud = UserDefaults.standard
    @objc dynamic var selectedDate: Date = Date()
    
    private init() {
        
    }
        
    var themeColor: UIColor {
        set {
            let color = newValue.cgColor
            
            if let components = color.components {
                ud.set(components, forKey: "themeColor")
            }
            
        }
        get {
            guard let array = ud.object(forKey: "themeColor") as? [CGFloat] else { return .blue }
            
            let color = UIColor(red: array[0], green: array[1], blue: array[2], alpha: array[3])
            return color
        }
    }
    
    func removeInfo(userId: String) {
        ud.removeObject(forKey: userId)
    }
    
    var expensesGroupId: String {
        set {
            ud.set(newValue, forKey: "expensesGroupId")
        }
        get {
            return ud.string(forKey: "expensesGroupId") ?? "0"
        }
    }
    
    var expensesTypeId: String {
        set {
            ud.set(newValue, forKey: "expensesTypeId")
        }
        get {
            return ud.string(forKey: "expensesTypeId") ?? "0"
        }
    }
    
    var incomeGroupId: String {
        set {
            ud.set(newValue, forKey: "incomeGroupId")
        }
        get {
            return ud.string(forKey: "incomeGroupId") ?? "0"
        }
    }
    
    var incomeTypeId: String {
        set {
            ud.set(newValue, forKey: "incomeTypeId")
        }
        get {
            return ud.string(forKey: "incomeTypeId") ?? "0"
        }
    }
    
    var transferGroupId: String {
        set {
            ud.set(newValue, forKey: "transferGroupId")
        }
        get {
            return ud.string(forKey: "transferGroupId") ?? "0"
        }
    }
    
    var trnasferTypeId: String {
        set {
            ud.set(newValue, forKey: "trnasferTypeId")
        }
        get {
            return ud.string(forKey: "trnasferTypeId") ?? "0"
        }
    }
    
    var accountId: String {
        set {
            ud.set(newValue, forKey: "accountId")
        }
        get {
            if let id = ud.string(forKey: "accountId") {
                return id
            } else {
                return ""
            }
        }
    }
    
    var transferToAccountId: String {
        set {
            ud.set(newValue, forKey: "transferToAccountId")
        }
        get {
            if let id = ud.string(forKey: "transferToAccountId") {
                return id
            } else {
                return ""
            }
        }
    }
}
