//
//  AddDetailViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/26.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class AddDetailViewModel: BaseViewModel {
    
    private let amountRelay = BehaviorRelay<String>(value: "0")
    private(set) lazy var amount = amountRelay.asDriver(onErrorJustReturn: "0")
    
    private let transferFeeRelay = BehaviorRelay<String>(value: "0")
    private(set) lazy var transferFee = transferFeeRelay.asDriver()
    
    private let isShowCalcutorRelay = BehaviorRelay<Bool>(value: false)
    private(set) lazy var isShowCalcutor = isShowCalcutorRelay.asDriver()
    
    private let billingSegmentRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var billingSegment = billingSegmentRelay.asDriver()
    
    private let addDetailCellModelsRelay = BehaviorRelay<[String]>(value: [R.string.localizable.type_title(),
                                                                           R.string.localizable.account_title(),
                                                                           R.string.localizable.memo_title()])
    private(set) lazy var addDetailCellModels = addDetailCellModelsRelay.asDriver()
    
    private var detail = DetailModel()
    private let detailGroupModelsRelay = BehaviorRelay<[DetailGroupModel]>(value: [])
    private(set) lazy var detailGroupModels = detailGroupModelsRelay.asDriver()
    
    private let detailTypeModelsRelay = BehaviorRelay<[DetailTypeModel]>(value: [])
    private(set) lazy var detailTypeModels = detailTypeModelsRelay.asDriver()
    
    private var billingType: BillingType = .spend
    private let typeNameRelay = BehaviorRelay<String>(value: "")
    private(set) lazy var typeName = typeNameRelay.asDriver()
    
    private var selectedDetailGroupId: String = UserInfo.share.expensesGroupId
    private let detailGroupIdRelay = BehaviorRelay<String>(value: UserInfo.share.expensesGroupId)
    private(set) lazy var detailGroupId = detailGroupIdRelay.asDriver()
    
    private let detailTypeIdRelay = BehaviorRelay<String>(value: UserInfo.share.expensesTypeId)
    private(set) lazy var detailTypeId = detailTypeIdRelay.asDriver()
    
    private var accountId = UserInfo.share.accountId
    private let accountNameRelay = BehaviorRelay<String>(value: "")
    private(set) lazy var accountName = accountNameRelay.asDriver()
    
    private let accountModelsRelay = BehaviorRelay<[AccountModel]>(value: [])
    private(set) lazy var accountModels = accountModelsRelay.asDriver()
    
    private var toAccountId = UserInfo.share.transferToAccountId
    private let toAccountNameRelay = BehaviorRelay<String>(value: "")
    private(set) lazy var toAccountName = toAccountNameRelay.asDriver()
    
    private let memoRelay = BehaviorRelay<String>(value: "")
    private(set) lazy var memo = memoRelay.asDriver()
    
    private let memoModelsRelay = BehaviorRelay<[MemoModel]>(value: [])
    private(set) lazy var memoModels = memoModelsRelay.asDriver()
    
    private var isEdit = false
    
    override init() {
        super.init()
        
        detailGroupModelsRelay.accept(RealmManager.share.getDetailGroup(billType: billingType))
//        memoModelsRelay.accept(RealmManager.share.getCommonMemos(billingType: billingType.rawValue,
//                                                                 groupId: detailGroupIdRelay.value,
//                                                                 memo: memoRelay.value))
        setSelectValue()
        getAccountName()
    }
}


// MARK: Detail
extension AddDetailViewModel {
    
    func setEditData(_ data: DetailModel) {
        detail = data
        
        billingSegmentRelay.accept(data.billingType)
        amountRelay.accept(data.amount.string)
        detailGroupIdRelay.accept(data.detailGroup)
        detailTypeIdRelay.accept(data.detailType)
        memoRelay.accept(data.memo)
        
        setAccountId(data.accountId.stringValue)
        setToAccountId(data.toAccountId.stringValue)
        setSelectValue()
        
        isEdit = true
    }
    
    func saveDetail() {
        guard let amount = amountRelay.value.int, amount > 0, let accountId = try? ObjectId(string: accountId) else { return }
        
        if isEdit {
            resetDetailStatus()
            RealmManager.share.realm.beginWrite()
        }
        
        detail.billingType    = billingType.rawValue
        detail.accountId      = accountId
        detail.accountName    = accountNameRelay.value
        detail.detailGroup    = detailGroupIdRelay.value
        detail.detailType     = detailTypeIdRelay.value
        detail.amount         = amount
        detail.memo           = memoRelay.value
        detail.date           = UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd")
        detail.modifyDateTime = Date().string(withFormat: "yyyy-MM-dd")
        
        UserInfo.share.accountId = accountId.stringValue
        
        if billingType == .transfer, let toAccountId = try? ObjectId(string: toAccountId) {
            detail.toAccountId    = toAccountId
            detail.toAccountName  = toAccountNameRelay.value
            
            UserInfo.share.transferToAccountId = toAccountId.stringValue
        }
        
        if isEdit {
            try! RealmManager.share.realm.commitWrite()
        } else {
            
            switch billingType {
            case .spend:
                UserInfo.share.expensesGroupId = detailGroupIdRelay.value
                UserInfo.share.expensesTypeId = detailTypeIdRelay.value
            case .income:
                UserInfo.share.incomeGroupId = detailGroupIdRelay.value
                UserInfo.share.incomeTypeId = detailTypeIdRelay.value
            case .transfer:
                UserInfo.share.transferGroupId = detailGroupIdRelay.value
                UserInfo.share.trnasferTypeId = detailTypeIdRelay.value
            }
            
            RealmManager.share.saveData(detail)
        }
        
        if billingType == .transfer, let toAccountId = try? ObjectId(string: toAccountId) {
            RealmManager.share.updateAccountMoney(billingType: self.billingType, amount: amount, accountId: accountId, toAccountId: toAccountId)
        } else {
            RealmManager.share.updateAccountMoney(billingType: self.billingType, amount: amount, accountId: accountId)
        }
        
        // 新增手續費
        if let transferFee = transferFeeRelay.value.int, transferFee > 0 {
            let transferFeeModel = DetailModel()
            transferFeeModel.billingType    = 0
            transferFeeModel.accountId      = accountId
            transferFeeModel.accountName    = accountNameRelay.value
            transferFeeModel.detailGroup    = UserInfo.share.transferFeeGroupId
            transferFeeModel.detailType     = UserInfo.share.transferFeeTypeId
            transferFeeModel.amount         = transferFee
            transferFeeModel.memo           = "轉帳手續費"
            transferFeeModel.date           = UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd")
            transferFeeModel.modifyDateTime = Date().string(withFormat: "yyyy-MM-dd")
            
            RealmManager.share.saveData(transferFeeModel)
            RealmManager.share.updateAccountMoney(billingType: .spend, amount: transferFee, accountId: accountId)
        }
        
        // 儲存備註
        if !memoRelay.value.isEmpty {
            getMemos()
            if memoModelsRelay.value.count > 0, let model = memoModelsRelay.value.first {
                // 更新次數
                RealmManager.share.saveData(model, update: true)
            } else {
                let memoModel = MemoModel()
                memoModel.billingType = billingType.rawValue
                memoModel.detailGroup = detailGroupIdRelay.value
                memoModel.memo = memoRelay.value
                memoModel.count = 1
                RealmManager.share.saveData(memoModel)
            }
        }
        
    }
    
    func delDetail() {
        resetDetailStatus()
        RealmManager.share.delete(detail)
    }
    
    func setBillingType(_ billingType: BillingType) {
        self.billingType = billingType
        detailGroupModelsRelay.accept(RealmManager.share.getDetailGroup(billType: billingType))
        
        switch billingType {
        case .spend:
            addDetailCellModelsRelay.accept([R.string.localizable.type_title(),
                                             R.string.localizable.account_title(),
                                             R.string.localizable.memo_title()])
            detailGroupIdRelay.accept(UserInfo.share.expensesGroupId)
            detailTypeIdRelay.accept(UserInfo.share.expensesTypeId)
        case .income:
            addDetailCellModelsRelay.accept([R.string.localizable.type_title(),
                                             R.string.localizable.account_title(),
                                             R.string.localizable.memo_title()])
            detailGroupIdRelay.accept(UserInfo.share.incomeGroupId)
            detailTypeIdRelay.accept(UserInfo.share.incomeTypeId)
        case .transfer:
            addDetailCellModelsRelay.accept([R.string.localizable.from_title(),
                                             R.string.localizable.to_title(),
                                             R.string.localizable.handlingfee_title(),
                                             R.string.localizable.type_title(),
                                             R.string.localizable.memo_title()])
            detailGroupIdRelay.accept(UserInfo.share.transferGroupId)
            detailTypeIdRelay.accept(UserInfo.share.trnasferTypeId)
        }
        
        setSelectValue()
    }
    
    private func resetDetailStatus() {
        if let billingType = BillingType(rawValue: detail.billingType) {
            // expenses -> other
            if billingType == .spend {
                RealmManager.share.updateAccountMoney(billingType: .income, amount: detail.amount, accountId: self.detail.accountId)
            }
            
            // income -> other
            if billingType == .income {
                RealmManager.share.updateAccountMoney(billingType: .spend, amount: detail.amount, accountId: detail.accountId)
            }
            
            // transfer -> other
            if billingType == .transfer {
                RealmManager.share.updateAccountMoney(billingType: .transfer, amount: detail.amount, accountId: detail.toAccountId, toAccountId: self.detail.accountId)
            }
        }
    }
}


// MARK: Selected Group
extension AddDetailViewModel {
    func setSelectGroup(_ groupId: String) {
        selectedDetailGroupId = groupId
        detailTypeModelsRelay.accept(RealmManager.share.getDetailType(groupId))
    }
    
    func setSelectType(_ typeId: String) {
        detailGroupIdRelay.accept(selectedDetailGroupId)
        detailTypeIdRelay.accept(typeId)
        setSelectValue()
    }
    
    private func setSelectValue() {
        typeNameRelay.accept(DBTools.detailTypeToString(billingType: billingType,
                                                        detailGroupId: detailGroupIdRelay.value,
                                                        detailTypeId: detailTypeIdRelay.value))
    }
}


// MARK: Memo
extension AddDetailViewModel {
    func getMemos() {
        memoModelsRelay.accept(RealmManager.share.getCommonMemos(billingType: billingType.rawValue,
                                                                 groupId: detailGroupIdRelay.value,
                                                                 memo: memoRelay.value))
    }
}


// MARK: Group
extension AddDetailViewModel {
    func addGroup(_ groupName: String) {
        let group = DetailGroupModel()
        group.billType = billingType.rawValue
        group.name = groupName
        RealmManager.share.saveData(group)
        
        setSelectGroup(group.id.stringValue)
        setSelectType(group.id.stringValue)
        detailGroupModelsRelay.accept(RealmManager.share.getDetailGroup(billType: billingType))
    }
    
    func deleteGroup(_ model: DetailGroupModel) {
        var models = detailGroupModelsRelay.value
        detailGroupModelsRelay.accept(models.removeAll(model))
        RealmManager.share.delete(model)
        
        detailTypeModelsRelay.value.forEach { typeModel in
            RealmManager.share.delete(typeModel)
        }
        
        if detailGroupModelsRelay.value.first?.id.stringValue != nil {
            setBillingType(billingType)
        }
    }
    
    func addType(_ typeName: String) {
        let type = DetailTypeModel()
        type.groupId = detailGroupIdRelay.value
        type.name = typeName
        RealmManager.share.saveData(type)
        
        setSelectGroup(detailGroupIdRelay.value)
    }
    
    func deleteType(_ model: DetailTypeModel) {
        var models = detailTypeModelsRelay.value
        detailTypeModelsRelay.accept(models.removeAll(model))
        RealmManager.share.delete(model)
    }
}


// MARK: Set Method
extension AddDetailViewModel {
    func setAccountId(_ accountId: String) {
        self.accountId = accountId
        getAccountName()
    }
    
    func setToAccountId(_ toAccountId: String) {
        self.toAccountId = toAccountId
        getAccountName()
    }
    
    func setAmount(_ amount: String) {
        amountRelay.accept(amount)
    }
    
    func setTransferFee(_ transferFee: String) {
        transferFeeRelay.accept(transferFee)
    }
    
    func setShowCalcutor(_ show: Bool) {
        isShowCalcutorRelay.accept(show)
    }
    
    func setMemo(_ memoString: String) {
        memoRelay.accept(memoString)
        getMemos()
    }
    
    func setBillingSegmentIndex(_ index: Int) {
        billingSegmentRelay.accept(index)
    }
}

// MARK: Get Method
extension AddDetailViewModel {
    func getGroupId() -> String {
        return detailGroupIdRelay.value
    }
    
    func getTypeId() -> String {
        return detailTypeIdRelay.value
    }
    
    func getAccountId() -> String {
        return self.accountId
    }
    
    func getToAccountId() -> String{
        return self.toAccountId
    }
    
    func getAccounts() {
        accountModelsRelay.accept(RealmManager.share.getAccount())
    }
    
    private func getAccountName() {
        if !accountId.isEmpty {
            accountNameRelay.accept(RealmManager.share.getAccount(accountId).first?.name ?? "")
        }
        
        if !toAccountId.isEmpty {
            toAccountNameRelay.accept(RealmManager.share.getAccount(toAccountId).first?.name ?? "")
        }
    }
    
    func getSegmentIndex() -> Int {
        return billingSegmentRelay.value
    }
}
