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
            return ud.string(forKey: "expensesGroupId") ?? RealmManager.share.getDetailGroup(billType: .spend).first?.id.stringValue ?? ""
        }
    }
    
    var expensesTypeId: String {
        set {
            ud.set(newValue, forKey: "expensesTypeId")
        }
        get {
            return ud.string(forKey: "expensesTypeId") ?? RealmManager.share.getDetailType(self.expensesGroupId).first?.id.stringValue ?? ""
        }
    }
    
    var incomeGroupId: String {
        set {
            ud.set(newValue, forKey: "incomeGroupId")
        }
        get {
            return ud.string(forKey: "incomeGroupId") ?? RealmManager.share.getDetailGroup(billType: .income).first?.id.stringValue ?? ""
        }
    }
    
    var incomeTypeId: String {
        set {
            ud.set(newValue, forKey: "incomeTypeId")
        }
        get {
            return ud.string(forKey: "incomeTypeId") ?? RealmManager.share.getDetailType(self.incomeGroupId).first?.id.stringValue ?? ""
        }
    }
    
    var transferGroupId: String {
        set {
            ud.set(newValue, forKey: "transferGroupId")
        }
        get {
            return ud.string(forKey: "transferGroupId") ?? RealmManager.share.getDetailGroup(billType: .transfer).first?.id.stringValue ?? ""
        }
    }
    
    var trnasferTypeId: String {
        set {
            ud.set(newValue, forKey: "trnasferTypeId")
        }
        get {
            return ud.string(forKey: "trnasferTypeId") ?? RealmManager.share.getDetailType(self.transferGroupId).first?.id.stringValue ?? ""
        }
    }
    
    var accountId: String {
        set {
            ud.set(newValue, forKey: "accountId")
        }
        get {
            return ud.string(forKey: "accountId") ?? RealmManager.share.getAccount().first?.id.stringValue ?? ""
        }
    }
    
    var transferToAccountId: String {
        set {
            ud.set(newValue, forKey: "transferToAccountId")
        }
        get {
            return ud.string(forKey: "transferToAccountId") ?? RealmManager.share.getAccount().first?.id.stringValue ?? ""
        }
    }
    
    
    var transferFeeGroupId: String {
        set {
            ud.set(newValue, forKey: "transferFeeGroupId")
        }
        get {
            return ud.string(forKey: "transferFeeGroupId") ?? ""
        }
    }
    
    var transferFeeTypeId: String {
        set {
            ud.set(newValue, forKey: "transferFeeTypeId")
        }
        get {
            return ud.string(forKey: "transferFeeTypeId") ?? ""
        }
    }
    
}
