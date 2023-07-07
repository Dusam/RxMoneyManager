//
//  AddAccountViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/17.
//

import Foundation
import RxSwift
import RxCocoa

class AddAccountViewModel: BaseViewModel {
    
    private var type: AccountType = .cash
    
    private let accountNameRelay = BehaviorRelay<String>(value: "")
    private(set) lazy var accountName = accountNameRelay.asDriver()
    
    private let initAmountRelay = BehaviorRelay<String>(value: "0")
    private(set) lazy var initAmount = initAmountRelay.asDriver()
    
    private let joinTotalRelay = BehaviorRelay<Bool>(value: true)
    private(set) lazy var joinTotal = joinTotalRelay.asDriver()
    
    
    func setAccountType(_ type: AccountType) {
        self.type = type
    }
    
    func saveAccount() {
        guard let initAmount = initAmountRelay.value.int, !accountNameRelay.value.isEmpty else { return }
        
        let account = AccountModel()
        account.type = type.rawValue
        account.name = accountNameRelay.value
        account.money = initAmount
        account.initMoney = initAmount
        account.includTotal = joinTotalRelay.value
        
        RealmManager.share.saveData(account)
    }

}

// MARK: Set method
extension AddAccountViewModel {
    func setAccountName(_ name: String) {
        accountNameRelay.accept(name)
    }
    
    func setAmount(_ amount: String) {
        initAmountRelay.accept(amount)
    }
    
    func setJoinTotal(_ isOn: Bool) {
        joinTotalRelay.accept(isOn)
    }
}
