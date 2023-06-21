//
//  RealmMigration.swift
//  MoneyManager
//
//  Created by Qian-Yu Du on 2022/5/19.
//

import Foundation
import RealmSwift



class RealmManager {
    static let share = RealmManager()
    
    private(set) var realm: Realm!
            
    private init() {
        openRealm()
    }
    
    func openRealm() {
        do {
            // Setting the schema version
            var config = Realm.Configuration(schemaVersion: 2) { migration, oldSchemaVersion in
//                練習範例
//                if oldSchemaVersion < 8 {
//                    migration.enumerateObjects(ofType: "RLM_Account") { oldObject, newObject in
//                        newObject?["enable"] = true
//                    }
//                }
//
//                if oldSchemaVersion < 10 {
//                    migration.enumerateObjects(ofType: "RLM_Account") { oldObject, newObject in
//                        newObject?["disable2"] = true
//                    }
//                }
//
//                if oldSchemaVersion < 3 {
//                    migration.renameProperty(onType: DetailModel.className(), from: "accountType", to: "accountId")
//                    migration.renameProperty(onType: DetailModel.className(), from: "toAccountType", to: "toAccountId")
//                }
                
            }
            
            config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("MoneyManager.realm")
            
            #if DEBUG
            print("realm url: \(config.fileURL!.path)")
            #endif
            
            Realm.Configuration.defaultConfiguration = config
            
            realm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func saveData(_ data: Object, update: Bool = false) {
        if let realm = realm {
            if !realm.isInWriteTransaction {
                realm.beginWrite()
            }
            
            if update, let memoModel = data as? MemoModel {
                memoModel.count += 1
            }
            
            realm.add(data, update: .modified)
            try! realm.commitWrite()
        }
    }
    
}

// MARK: Detail Method
extension RealmManager {
//    func saveDetail(_ detailModel: Object) {
//        if let realm = realm {
//            realm.beginWrite()
//            realm.add(detailModel, update: .modified)
//            try! realm.commitWrite()
//        }
//    }
    
    func readDetail(_ date: String) -> [DetailModel] {
        if let realm = realm {
            return Array(realm.objects(DetailModel.self)).filter {
                $0.date == date
            }
        }
        return []
    }
    
    func deleteDetail(_ id: ObjectId) {
        if let realm = realm {
            let delete = realm.objects(DetailModel.self).filter("id == %@", id)
            
            realm.beginWrite()
            realm.delete(delete)
            try! realm.commitWrite()
        }
    }
    
    func searchDeatilWithDateRange(_ startDate: Date, _ endDate: Date) -> [DetailModel] {
        if let realm = realm {
            let datas = Array(realm.objects(DetailModel.self))
            
            return datas.filter {
                if let date = $0.date.date(withFormat: "yyyy-MM-dd"), date.isBetween(startDate, endDate) {
                    return true
                }
                return false
            }
        }
                              
        return []
    }
    
//    func saveCommonMemo(memoModel: MemoModel, update: Bool = false) {
//        realm.beginWrite()
//        if update {
//            memoModel.count += 1
//        }
//        realm.add(memoModel, update: .modified)
//        try! realm.commitWrite()
//    }
    
    func getCommonMemos(billingType: Int, groupId: String, memo: String) -> [MemoModel] {
        if memo.isEmpty {
            return Array(realm.objects(MemoModel.self)).filter {
                $0.billingType == billingType && $0.detailGroup == groupId
            }
            .sorted{ $0.count > $1.count}
        } else {
            return Array(realm.objects(MemoModel.self)).filter {
                $0.billingType == billingType && $0.detailGroup == groupId
            }
            .filter {$0.memo.contains(memo)}
            .sorted{ $0.count > $1.count}
        }
        
    }
}

// MARK: Account Method
extension RealmManager {
//    func saveAccount(_ accountlModel: AccountModel) {
//        if let realm = realm {
//            realm.beginWrite()
//            realm.add(accountlModel, update: .modified)
//            try! realm.commitWrite()
//        }
//    }
    
//    func updateAccountMoney(billingType: BillingType, amount: Int, accountId: ObjectId, toAccountId: ObjectId = ObjectId()) {
//
//        switch billingType {
//        case .expenses:
//            let account = realm.objects(AccountModel.self).where {
//                $0.id == accountId
//            }.first
//
//            try! realm.write {
//                account?.money -= amount
//            }
//
//
//        case .income:
//            let account = realm.objects(AccountModel.self).where {
//                $0.id == accountId
//            }.first
//
//            try! realm.write {
//                account?.money += amount
//            }
//
//        case .transfer:
//            let account = realm.objects(AccountModel.self).where {
//                $0.id == accountId
//            }.first
//
//            let toAccount = realm.objects(AccountModel.self).where {
//                $0.id == toAccountId
//            }.first
//
//            try! realm.write {
//                account?.money -= amount
//                toAccount?.money += amount
//            }
//        }
//    }
}

// MARK: 使用者自訂的帳戶、群組及類型
extension RealmManager {
    func getAccount(_ id: String = "") -> [AccountModel] {
        if let realm = realm {
            
            if id.isEmpty {
                return Array(realm.objects(AccountModel.self))
            } else if let id = try? ObjectId(string: id) {
                return Array(realm.objects(AccountModel.self)).filter {
                    $0.id == id
                }
            }
        }
        return []
    }
    
    func getDetailGroup(billType: BillingType, groupId: String = "") -> [DetailGroupModel] {
        if let realm = realm {

            if groupId.isEmpty {
                return Array(realm.objects(DetailGroupModel.self)).filter {
                    $0.billType == billType.rawValue
                }
            } else if let id = try? ObjectId(string: groupId) {
                return Array(realm.objects(DetailGroupModel.self)).filter {
                    $0.id == id && $0.billType == billType.rawValue
                }
            }

        }

        return []
    }
    
    func getDetailType(_ groupId: String = "", typeId: String = "") -> [DetailTypeModel] {
        if let realm = realm {
            
            if !groupId.isEmpty {
                return Array(realm.objects(DetailTypeModel.self)).filter {
                    $0.groupId == groupId
                }
            } else if typeId.isEmpty {
                return Array(realm.objects(DetailTypeModel.self))
            } else {
                return Array(realm.objects(DetailTypeModel.self)).filter {
                    $0.id.stringValue == typeId
                }
            }
            
        }
        
        return []
    }
}
