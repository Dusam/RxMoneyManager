//
//  AddDetailViewModelType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

import Foundation

protocol AddDetailViewModelType: CalculatorViewModelType {
    var input: AddDetailViewModel.Input! { get }
    var output: AddDetailViewModel.Output! { get }
    
    func setEditData(_ data: DetailModel)
    func saveDetail()
    func delDetail()
    func setBillingType(_ billingType: BillingType)
    
    func setSelectGroup(_ groupId: String)
    func setSelectType(_ typeId: String)
    
    func getMemos()
    
    func addGroup(_ groupName: String)
    func deleteGroup(_ model: DetailGroupModel)
    func addType(_ typeName: String)
    func deleteType(_ model: DetailTypeModel)
    
    func setAccountId(_ accountId: String)
    func setToAccountId(_ toAccountId: String)
    func setMemo(_ memoString: String)
    
    func getGroupId() -> String
    func getTypeId() -> String
    func getAccountId() -> String
    func getToAccountId() -> String
    func getAccounts()
}
