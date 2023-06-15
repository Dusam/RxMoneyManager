//
//  InitialDB.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/24.
//

import Foundation
import RealmSwift


extension RealmManager {
    // MARK: 建立預設選項
    internal func setUpPresetOptions() {
        realm.beginWrite()
        self.presetAccount(realm)
        self.presetExpensesGroup(realm)
        self.presetIncomeGroup(realm)
        self.presetTransferGroup(realm)
        try! realm.commitWrite()
    }
    
    private func presetAccount(_ realm: Realm) {
        let accountModel = AccountModel()
        accountModel.type = 0
        accountModel.name = "現金"
        accountModel.money = 0
        accountModel.includTotal = true
        
        UserInfo.share.accountId = accountModel.id.stringValue
        UserInfo.share.transferToAccountId = accountModel.id.stringValue
        realm.add(accountModel)
    }
}

// MARK: 支出類型
extension RealmManager {
    private func presetExpensesGroup(_ realm: Realm) {
        let expensesGroups = ExpensesGroup.allCases
        
        for expensesGroup in expensesGroups {
//            let expensesGroupModel = ExpensesGroupModel()
            let expensesGroupModel = DetailGroupModel()
            expensesGroupModel.name = expensesGroup.name
            expensesGroupModel.billType = 0
            
            realm.add(expensesGroupModel)
            
            // 根據各群組建立該群組的支出類型
            switch expensesGroup {
            case .food:
                self.presetFoodType(realm, expensesGroupModel.id)
            case .clothing:
                self.presetClothingType(realm, expensesGroupModel.id)
            case .life:
                self.presetLifeType(realm, expensesGroupModel.id)
            case .traffic:
                self.presetTrafficType(realm, expensesGroupModel.id)
            case .educate:
                self.presetEducateType(realm, expensesGroupModel.id)
            case .entertainment:
                self.presetEntertainmentType(realm, expensesGroupModel.id)
            case .electronicProduct:
                self.presetElectronicProductType(realm, expensesGroupModel.id)
            case .book:
                self.presetBookType(realm, expensesGroupModel.id)
            case .motor:
                self.presetMotorType(realm, expensesGroupModel.id)
            case .medical:
                self.presetMedicalType(realm, expensesGroupModel.id)
            case .personalCommunication:
                self.presetPersonalCommunicationType(realm, expensesGroupModel.id)
            case .invest:
                self.presetInvestType(realm, expensesGroupModel.id)
            case .other:
                self.presetOtherType(realm, expensesGroupModel.id)
            case .fee:
                self.presetFeeType(realm, expensesGroupModel.id)
            }
        }
    }
    
    private func presetFoodType(_ realm: Realm, _ groupId: ObjectId) {
        let foods = ExpensesFood.allCases
        
        UserInfo.share.expensesGroupId = groupId.stringValue
        
        for food in foods {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = food.name
            
            if food.name == ExpensesFood.lunch.name {
                UserInfo.share.expensesTypeId = model.id.stringValue
            }
            
            realm.add(model)
        }
    }
    
    private func presetClothingType(_ realm: Realm, _ groupId: ObjectId) {
        let clothings = ExpensesClothing.allCases
        
        for clothing in clothings {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = clothing.name
            
            realm.add(model)
        }
    }
    
    private func presetLifeType(_ realm: Realm, _ groupId: ObjectId) {
        let lifes = ExpensesLife.allCases
        
        for life in lifes {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = life.name
            
            realm.add(model)
        }
    }
    
    private func presetTrafficType(_ realm: Realm, _ groupId: ObjectId) {
        let traffics = ExpensesTraffic.allCases
        
        for traffic in traffics {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = traffic.name
            
            realm.add(model)
        }
    }
    
    private func presetEducateType(_ realm: Realm, _ groupId: ObjectId) {
        let educates = ExpensesEducate.allCases
        
        for educate in educates {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = educate.name
            
            realm.add(model)
        }
    }
    
    private func presetEntertainmentType(_ realm: Realm, _ groupId: ObjectId) {
        let entertainments = ExpensesEntertainment.allCases
        
        for entertainment in entertainments {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = entertainment.name
            
            realm.add(model)
        }
    }
    
    private func presetElectronicProductType(_ realm: Realm, _ groupId: ObjectId) {
        let electronicProducts = ExpensesElectronicProduct.allCases
        
        for electronicProduct in electronicProducts {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = electronicProduct.name
            
            realm.add(model)
        }
    }
    
    private func presetBookType(_ realm: Realm, _ groupId: ObjectId) {
        let books = ExpensesBook.allCases
        
        for book in books {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = book.name
            
            realm.add(model)
        }
    }
    
    private func presetMotorType(_ realm: Realm, _ groupId: ObjectId) {
        let motors = ExpensesMotor.allCases
        
        for motor in motors {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = motor.name
            
            realm.add(model)
        }
    }
    
    private func presetMedicalType(_ realm: Realm, _ groupId: ObjectId) {
        let medicals = ExpensesMedical.allCases
        
        for medical in medicals {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = medical.name
            
            realm.add(model)
        }
    }
    
    private func presetPersonalCommunicationType(_ realm: Realm, _ groupId: ObjectId) {
        let personalCommunications = ExpensesPersonalCommunication.allCases
        
        for personalCommunication in personalCommunications {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = personalCommunication.name
            
            realm.add(model)
        }
    }
    
    private func presetInvestType(_ realm: Realm, _ groupId: ObjectId) {
        let invests = ExpensesInvest.allCases
        
        for invest in invests {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = invest.name
            
            realm.add(model)
        }
    }
    
    private func presetOtherType(_ realm: Realm, _ groupId: ObjectId) {
        let others = ExpensesOther.allCases
        
        for other in others {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = other.name
            
            realm.add(model)
        }
    }
    
    private func presetFeeType(_ realm: Realm, _ groupId: ObjectId) {
        let fees = ExpensesFee.allCases
        UserInfo.share.transferFeeGroupId = groupId.stringValue
        
        for fee in fees {
//            let model = ExpensesTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = fee.name
            UserInfo.share.transferFeeTypeId = model.id.stringValue
            
            realm.add(model)
        }
    }
    
}

// MARK: 收入類型
extension RealmManager {
    private func presetIncomeGroup(_ realm: Realm) {
        let incomeGroups = IncomeGroup.allCases
        
        for incomeGroup in incomeGroups {
//            let incomeGroupModel = IncomeGroupModel()
            let incomeGroupModel = DetailGroupModel()
            incomeGroupModel.name = incomeGroup.name
            incomeGroupModel.billType = 1
            
            realm.add(incomeGroupModel)
            
            // 根據各群組建立該群組的支出類型
            switch incomeGroup {
            case .general:
                self.presetGeneralType(realm, incomeGroupModel.id)
            case .investment:
                self.presetInvestmentType(realm, incomeGroupModel.id)
            }
        }
    }
    
    private func presetGeneralType(_ realm: Realm, _ groupId: ObjectId) {
        let generals = IncomeGeneral.allCases
        
        UserInfo.share.incomeGroupId = groupId.stringValue
        
        for general in generals {
//            let model = IncomeTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = general.name
            
            if general.name == IncomeGeneral.other.name {
                UserInfo.share.incomeTypeId = model.id.stringValue
            }
            
            realm.add(model)
        }
    }
    
    private func presetInvestmentType(_ realm: Realm, _ groupId: ObjectId) {
        let investments = IncomeInvestment.allCases
        
        for investment in investments {
//            let model = IncomeTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = investment.name
            
            realm.add(model)
        }
    }
}

// MARK: 轉帳類型
extension RealmManager {
    private func presetTransferGroup(_ realm: Realm) {
        let transferGroups = TransferGroup.allCases
        
        for transferGroup in transferGroups {
//            let transferGroupModel = TransferGroupModel()
            let transferGroupModel = DetailGroupModel()
            transferGroupModel.name = transferGroup.name
            transferGroupModel.billType = 2
            
            realm.add(transferGroupModel)
            
            // 根據各群組建立該群組的轉帳類型
            switch transferGroup {
            case .transferMoney:
                self.presetTransferType(realm, transferGroupModel.id)
            }
        }
    }
    
    private func presetTransferType(_ realm: Realm, _ groupId: ObjectId) {
        let generals = TransferGeneral.allCases
        
        UserInfo.share.transferGroupId = groupId.stringValue
        
        for general in generals {
//            let model = TransferTypeModel()
            let model = DetailTypeModel()
            model.groupId = groupId.stringValue
            model.name = general.name
            
            
            if general.name == TransferGeneral.general.name {
                UserInfo.share.trnasferTypeId = model.id.stringValue
            }
            
            realm.add(model)
        }
    }
}
