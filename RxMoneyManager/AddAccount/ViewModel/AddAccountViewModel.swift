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
    let accountName = BehaviorRelay<String>(value: "")
    let initAmount = BehaviorRelay<String>(value: "0")
    let joinTotal = BehaviorRelay<Bool>(value: true)
    
    
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
