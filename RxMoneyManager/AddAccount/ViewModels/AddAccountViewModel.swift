//
//  AddAccountViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/17.
//

import Foundation
import RxSwift
import RxCocoa

class AddAccountViewModel: AddAccountViewModelType {
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private(set) var type: AccountType = .cash
    
    private let accountName = BehaviorRelay<String>(value: "")
    private let initAmount = BehaviorRelay<String>(value: "0")
    private let joinTotal = BehaviorRelay<Bool>(value: true)
    private let isShowCalcutor = BehaviorRelay<Bool>(value: false)
    
    init() {
        
        input = .init(accountName: accountName,
                      initAmount: initAmount,
                      joinTotal: joinTotal,
                      isShowCalcutor: isShowCalcutor)
        
        output = .init(accountName: accountName.asDriver(),
                       initAmount: initAmount.asDriver(),
                       joinTotal: joinTotal.asDriver(),
                       isShowCalcutor: isShowCalcutor.asDriver())
    }
    
    func setAccountType(_ type: AccountType) {
        self.type = type
    }

    func saveAccount() {
        guard let initAmount = initAmount.value.int, !accountName.value.isEmpty else { return }
        
        let account = AccountModel()
        account.type = type.rawValue
        account.name = accountName.value
        account.money = initAmount
        account.initMoney = initAmount
        account.includTotal = joinTotal.value
        
        RealmManager.share.saveData(account)
    }

}

extension AddAccountViewModel {
    struct Input {
        let accountName: BehaviorRelay<String>
        let initAmount: BehaviorRelay<String>
        let joinTotal: BehaviorRelay<Bool>
        let isShowCalcutor: BehaviorRelay<Bool>
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
    func setAmount(_ amount: String) {
        initAmount.accept(amount)
    }
    
    func setShowCalcutor(_ show: Bool) {
        isShowCalcutor.accept(show)
    }
}
