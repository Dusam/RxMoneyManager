//
//  AddAccountViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/17.
//

import Foundation
import RxSwift
import RxCocoa

class AddAccountViewModel: BaseViewModel, ViewModelType {
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private(set) var type: AccountType = .cash
    
    private let accountNameRelay = BehaviorRelay<String>(value: "")
    private(set) lazy var accountName = accountNameRelay.asDriver()
    
    private let initAmountRelay = BehaviorRelay<String>(value: "0")
    private(set) lazy var initAmount = initAmountRelay.asDriver()
    
    private let joinTotalRelay = BehaviorRelay<Bool>(value: true)
    private(set) lazy var joinTotal = joinTotalRelay.asDriver()
    
    private let isShowCalcutorRelay = BehaviorRelay<Bool>(value: false)
    private(set) lazy var isShowCalcutor = isShowCalcutorRelay.asDriver()
    
    
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

extension AddAccountViewModel {
    struct Input {
        let accountType: AnyObserver<AccountType>
        let accountName: AnyObserver<String>
        let initAmount: AnyObserver<String>
        let joinTotal: AnyObserver<Bool>
        let isShowCalcutor: AnyObserver<Bool>
    }
    
    struct Output {
        let accountName: Driver<String>
        let initAmount: Driver<String>
        let joinTotal: Driver<Bool>
        let isShowCalcutor: Driver<Bool>
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
    
    func setShowCalcutor(_ show: Bool) {
        isShowCalcutorRelay.accept(show)
    }
}
