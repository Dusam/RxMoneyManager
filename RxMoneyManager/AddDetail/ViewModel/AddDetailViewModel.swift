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
    
    let amount = BehaviorRelay<String>(value: "0")
    let transferFee = BehaviorRelay<String>(value: "0")
    let isShowCalcutor = BehaviorRelay<Bool>(value: false)
    let selectedSegmentRelay = BehaviorRelay<Int>(value: 0)
    let addDetailCellModels = BehaviorRelay<[String]>(value: ["類別:", "帳戶", "備註:"])
    
    private var detail = DetailModel()
    let detailGroupModels = BehaviorRelay<[DetailGroupModel]>(value: [])
    let detailTypeModels = BehaviorRelay<[DetailTypeModel]>(value: [])
    
    private var billingType: BillingType = .spend
    let typeName = BehaviorRelay<String>(value: "")
    private let detailGroupId = BehaviorRelay<String>(value: UserInfo.share.expensesGroupId)
    private let detailTypeId = BehaviorRelay<String>(value: UserInfo.share.expensesTypeId)
    
    private var accountId = UserInfo.share.accountId
    let accountName = BehaviorRelay<String>(value: "")
    
    private var toAccountId = UserInfo.share.transferToAccountId
    let toAccountName = BehaviorRelay<String>(value: "")
    
    let memo = BehaviorRelay<String>(value: "")
    
    
    private var isEdit = false
    
    override init() {
        super.init()
        
        detailGroupModels.accept(RealmManager.share.getDetailGroup(billType: billingType))
        setSelectValue()
        getAccountName()
    }
}

// MARK: Calcutor
extension AddDetailViewModel {
    func setShowCalcutor(_ show: Bool) {
        isShowCalcutor.accept(show)
    }
}


// MARK: Detail
extension AddDetailViewModel {
    
    func setEditData(_ data: DetailModel) {
        detail = data
        
        selectedSegmentRelay.accept(data.billingType)
        amount.accept(data.amount.string)
        detailGroupId.accept(data.detailGroup)
        detailTypeId.accept(data.detailType)
        memo.accept(data.memo)
        
        setAccountId(data.accountId.stringValue)
        setToAccountId(data.toAccountId.stringValue)
        setSelectValue()
        
        isEdit = true
    }
    
    func saveDetail() {
        guard let amount = amount.value.int, amount > 0, let accountId = try? ObjectId(string: accountId) else { return }
        
        if isEdit {
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
        }
        
    }
    
    func delDetail() {
        RealmManager.share.deleteDetail(detail.id)
    }
    
    func setBillingType(_ billingType: BillingType) {
        self.billingType = billingType
        detailGroupModels.accept(RealmManager.share.getDetailGroup(billType: billingType))
        
        switch billingType {
        case .spend:
            addDetailCellModels.accept(["類別:", "帳戶", "備註:"])
            detailGroupId.accept(UserInfo.share.expensesGroupId)
            detailTypeId.accept(UserInfo.share.expensesTypeId)
        case .income:
            addDetailCellModels.accept(["類別:", "帳戶", "備註:"])
            detailGroupId.accept(UserInfo.share.incomeGroupId)
            detailTypeId.accept(UserInfo.share.incomeTypeId)
        case .transfer:
            addDetailCellModels.accept(["從:", "到", "手續費:", "類別:", "備註:"])
            detailGroupId.accept(UserInfo.share.transferGroupId)
            detailTypeId.accept(UserInfo.share.trnasferTypeId)
        }
        
        setSelectValue()
    }
    
    func setAccountId(_ accountId: String) {
        self.accountId = accountId
        getAccountName()
    }
    
    func setToAccountId(_ toAccountId: String) {
        self.toAccountId = toAccountId
        getAccountName()
    }
    
    func getAccountName() {
        if !accountId.isEmpty {
            accountName.accept(RealmManager.share.getAccount(accountId).first?.name ?? "")
        }
        
        if !toAccountId.isEmpty {
            toAccountName.accept(RealmManager.share.getAccount(toAccountId).first?.name ?? "")
        }
    }
}


// MARK: Selected Group
extension AddDetailViewModel {
    func setSelectGroup(_ groupId: String) {
        detailGroupId.accept(groupId)
        detailTypeModels.accept(RealmManager.share.getDetailType(detailGroupId.value))
    }
    
    func setSelectType(_ typeId: String) {
        detailTypeId.accept(typeId)
        setSelectValue()
    }
    
    private func setSelectValue() {
        typeName.accept(DBTools.detailTypeToString(billingType: billingType, detailGroupId: detailGroupId.value, detailTypeId: detailTypeId.value))
    }
}
