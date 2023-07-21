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

class AddDetailViewModel: BaseViewModel, ViewModelType {
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let amount = BehaviorRelay<String>(value: "0")
    private let transferFee = BehaviorRelay<String>(value: "0")
    private let isShowCalcutor = BehaviorRelay<Bool>(value: false)
    private let billingSegment = BehaviorRelay<Int>(value: 0)
    private let addDetailViewCells = BehaviorRelay<[String]>(value: [R.string.localizable.type_title(),
                                                                     R.string.localizable.account_title(),
                                                                     R.string.localizable.memo_title()])
    
    private var detail = DetailModel()
    private let detailGroupModels = BehaviorRelay<[DetailGroupModel]>(value: [])
    private let detailTypeModels = BehaviorRelay<[DetailTypeModel]>(value: [])
    private var billingType: BillingType = .spend
    private let typeName = BehaviorRelay<String>(value: "")
    
    private var selectedDetailGroupId: String = UserInfo.share.expensesGroupId
    private let detailGroupId = BehaviorRelay<String>(value: UserInfo.share.expensesGroupId)
    private let detailTypeId = BehaviorRelay<String>(value: UserInfo.share.expensesTypeId)
    
    private var accountId = UserInfo.share.accountId
    private let accountName = BehaviorRelay<String>(value: "")
    private let accountModels = BehaviorRelay<[AccountModel]>(value: [])
    
    private var toAccountId = UserInfo.share.transferToAccountId
    private let toAccountName = BehaviorRelay<String>(value: "")
    
    private let memo = BehaviorRelay<String>(value: "")
    private let memoModels = BehaviorRelay<[MemoModel]>(value: [])
    
    private var isEdit = false
    
    override init() {
        super.init()
        
        input = .init(billingSegment: billingSegment,
                      isShowCalcutor: isShowCalcutor)
        output = .init(amount: amount.asDriver(),
                       transferFee: transferFee.asDriver(),
                       isShowCalcutor: isShowCalcutor.asDriver(),
                       billingSegment: billingSegment.asDriver(),
                       addDetailViewCells: addDetailViewCells.asDriver(),
                       detailGroupModels: detailGroupModels.asDriver(),
                       detailTypeModels: detailTypeModels.asDriver(),
                       typeName: typeName.asDriver(),
                       detailGroupId: detailGroupId.asDriver(),
                       detailTypeId: detailTypeId.asDriver(),
                       accountName: accountName.asDriver(),
                       accountModels: accountModels.asDriver(),
                       toAccountName: toAccountName.asDriver(),
                       memo: memo.asDriver(),
                       memoModels: memoModels.asDriver())
        
        detailGroupModels.accept(RealmManager.share.getDetailGroup(billType: billingType))
        setTypeName()
        getAccountName()
    }
}

extension AddDetailViewModel {
    struct Input {
        let billingSegment: BehaviorRelay<Int>
        let isShowCalcutor: BehaviorRelay<Bool>
    }
    
    struct Output {
        let amount: Driver<String>
        let transferFee: Driver<String>
        let isShowCalcutor: Driver<Bool>
        let billingSegment: Driver<Int>
        let addDetailViewCells: Driver<[String]>
        let detailGroupModels: Driver<[DetailGroupModel]>
        let detailTypeModels: Driver<[DetailTypeModel]>
        let typeName: Driver<String>
        let detailGroupId: Driver<String>
        let detailTypeId: Driver<String>
        let accountName: Driver<String>
        let accountModels: Driver<[AccountModel]>
        let toAccountName: Driver<String>
        let memo: Driver<String>
        let memoModels: Driver<[MemoModel]>
    }
}


// MARK: Detail
extension AddDetailViewModel {
    
    func setEditData(_ data: DetailModel) {
        detail = data
        
        billingSegment.accept(data.billingType)
        amount.accept(data.amount.string)
        detailGroupId.accept(data.detailGroup)
        detailTypeId.accept(data.detailType)
        memo.accept(data.memo)
        
        setAccountId(data.accountId.stringValue)
        setToAccountId(data.toAccountId.stringValue)
        setTypeName()
        
        isEdit = true
    }
    
    func saveDetail() {
        guard let amount = amount.value.int, amount > 0, let accountId = try? ObjectId(string: accountId) else { return }
        
        if isEdit {
            resetDetailStatus()
            RealmManager.share.realm.beginWrite()
        }
        
        detail.billingType    = billingType.rawValue
        detail.accountId      = accountId
        detail.accountName    = accountName.value
        detail.detailGroup    = detailGroupId.value
        detail.detailType     = detailTypeId.value
        detail.amount         = amount
        detail.memo           = memo.value
        detail.date           = UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd")
        detail.modifyDateTime = Date().string(withFormat: "yyyy-MM-dd")
        
        UserInfo.share.accountId = accountId.stringValue
        
        if billingType == .transfer, let toAccountId = try? ObjectId(string: toAccountId) {
            detail.toAccountId    = toAccountId
            detail.toAccountName  = toAccountName.value
            
            UserInfo.share.transferToAccountId = toAccountId.stringValue
        }
        
        if isEdit {
            try! RealmManager.share.realm.commitWrite()
        } else {
            
            switch billingType {
            case .spend:
                UserInfo.share.expensesGroupId = detailGroupId.value
                UserInfo.share.expensesTypeId = detailTypeId.value
            case .income:
                UserInfo.share.incomeGroupId = detailGroupId.value
                UserInfo.share.incomeTypeId = detailTypeId.value
            case .transfer:
                UserInfo.share.transferGroupId = detailGroupId.value
                UserInfo.share.trnasferTypeId = detailTypeId.value
            }
            
            RealmManager.share.saveData(detail)
        }
        
        if billingType == .transfer, let toAccountId = try? ObjectId(string: toAccountId) {
            RealmManager.share.updateAccountMoney(billingType: self.billingType, amount: amount, accountId: accountId, toAccountId: toAccountId)
        } else {
            RealmManager.share.updateAccountMoney(billingType: self.billingType, amount: amount, accountId: accountId)
        }
        
        // 新增手續費
        if let transferFee = transferFee.value.int, transferFee > 0 {
            let transferFeeModel = DetailModel()
            transferFeeModel.billingType    = 0
            transferFeeModel.accountId      = accountId
            transferFeeModel.accountName    = accountName.value
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
        if !memo.value.isEmpty {
            getMemos()
            if memoModels.value.count > 0, let model = memoModels.value.first {
                // 更新次數
                RealmManager.share.saveData(model, update: true)
            } else {
                let memoModel = MemoModel()
                memoModel.billingType = billingType.rawValue
                memoModel.detailGroup = detailGroupId.value
                memoModel.memo = memo.value
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
        detailGroupModels.accept(RealmManager.share.getDetailGroup(billType: billingType))
        
        switch billingType {
        case .spend:
            addDetailViewCells.accept([R.string.localizable.type_title(),
                                       R.string.localizable.account_title(),
                                       R.string.localizable.memo_title()])
            detailGroupId.accept(UserInfo.share.expensesGroupId)
            detailTypeId.accept(UserInfo.share.expensesTypeId)
        case .income:
            addDetailViewCells.accept([R.string.localizable.type_title(),
                                       R.string.localizable.account_title(),
                                       R.string.localizable.memo_title()])
            detailGroupId.accept(UserInfo.share.incomeGroupId)
            detailTypeId.accept(UserInfo.share.incomeTypeId)
        case .transfer:
            addDetailViewCells.accept([R.string.localizable.from_title(),
                                       R.string.localizable.to_title(),
                                       R.string.localizable.handlingfee_title(),
                                       R.string.localizable.type_title(),
                                       R.string.localizable.memo_title()])
            detailGroupId.accept(UserInfo.share.transferGroupId)
            detailTypeId.accept(UserInfo.share.trnasferTypeId)
        }
        
        setTypeName()
    }
    
    private func resetDetailStatus() {
        if let billingType = BillingType(rawValue: detail.billingType) {
            // expenses -> other
            if billingType == .spend {
                RealmManager.share.updateAccountMoney(billingType: .income, amount: detail.amount, accountId: detail.accountId)
            }
            
            // income -> other
            if billingType == .income {
                RealmManager.share.updateAccountMoney(billingType: .spend, amount: detail.amount, accountId: detail.accountId)
            }
            
            // transfer -> other
            if billingType == .transfer {
                RealmManager.share.updateAccountMoney(billingType: .transfer, amount: detail.amount, accountId: detail.toAccountId, toAccountId: detail.accountId)
            }
        }
    }
}


// MARK: Selected Group
extension AddDetailViewModel {
    func setSelectGroup(_ groupId: String) {
        selectedDetailGroupId = groupId
        detailTypeModels.accept(RealmManager.share.getDetailType(groupId))
    }
    
    func setSelectType(_ typeId: String) {
        detailGroupId.accept(selectedDetailGroupId)
        detailTypeId.accept(typeId)
        setTypeName()
    }
    
    private func setTypeName() {
        typeName.accept(DBTools.detailTypeToString(billingType: billingType,
                                                   detailGroupId: detailGroupId.value,
                                                   detailTypeId: detailTypeId.value))
    }
}


// MARK: Memo
extension AddDetailViewModel {
    func getMemos() {
        memoModels.accept(RealmManager.share.getCommonMemos(billingType: billingType.rawValue,
                                                            groupId: detailGroupId.value,
                                                            memo: memo.value))
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
        detailGroupModels.accept(RealmManager.share.getDetailGroup(billType: billingType))
    }
    
    func deleteGroup(_ model: DetailGroupModel) {
        var models = detailGroupModels.value
        detailGroupModels.accept(models.removeAll(model))
        RealmManager.share.delete(model)
        
        detailTypeModels.value.forEach { typeModel in
            RealmManager.share.delete(typeModel)
        }
        
        if detailGroupModels.value.first?.id.stringValue != nil {
            setBillingType(billingType)
        }
    }
    
    func addType(_ typeName: String) {
        let type = DetailTypeModel()
        type.groupId = detailGroupId.value
        type.name = typeName
        RealmManager.share.saveData(type)
        
        setSelectGroup(detailGroupId.value)
    }
    
    func deleteType(_ model: DetailTypeModel) {
        var models = detailTypeModels.value
        detailTypeModels.accept(models.removeAll(model))
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
    
    func setAmount(_ amountValue: String) {
        amount.accept(amountValue)
    }
    
    func setTransferFee(_ transferFeeValue: String) {
        transferFee.accept(transferFeeValue)
    }
    
    func setShowCalcutor(_ show: Bool) {
        isShowCalcutor.accept(show)
    }
    
    func setMemo(_ memoString: String) {
        memo.accept(memoString)
        getMemos()
    }
}

// MARK: Get Method
extension AddDetailViewModel {
    func getGroupId() -> String {
        return detailGroupId.value
    }
    
    func getTypeId() -> String {
        return detailTypeId.value
    }
    
    func getAccountId() -> String {
        return self.accountId
    }
    
    func getToAccountId() -> String{
        return self.toAccountId
    }
    
    func getAccounts() {
        accountModels.accept(RealmManager.share.getAccount())
    }
    
    private func getAccountName() {
        if !accountId.isEmpty {
            accountName.accept(RealmManager.share.getAccount(accountId).first?.name ?? "")
        }
        
        if !toAccountId.isEmpty {
            toAccountName.accept(RealmManager.share.getAccount(toAccountId).first?.name ?? "")
        }
    }
}
