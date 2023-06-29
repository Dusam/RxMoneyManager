//
//  AccountViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/26.
//

import Foundation
import RxCocoa
import RxSwift

class AccountViewModel: BaseViewModel {
    
    let sections = BehaviorRelay<[AccountSectionModel]>(value: [])
    let totalAssets = BehaviorRelay<Int>(value: 0)
    let totalLiability = BehaviorRelay<Int>(value: 0)
    let balance = BehaviorRelay<Int>(value: 0)
    
    private var includeTotalAccounts: [AccountModel] = []
    private var notIncludeTotalAccounts: [AccountModel] = []
}

extension AccountViewModel {
    func getAccounts() {
        totalAssets.accept(0)
        totalLiability.accept(0)
        balance.accept(0)
        includeTotalAccounts.removeAll()
        notIncludeTotalAccounts.removeAll()
        
        let accounts = RealmManager.share.getAccount()
        
        includeTotalAccounts = accounts.filter { $0.includTotal }
        notIncludeTotalAccounts = accounts.filter { !$0.includTotal}
        
        includeTotalAccounts.forEach { account in
            if account.money >= 0 {
                totalAssets.accept(totalAssets.value + account.money)
            } else {
                totalLiability.accept(totalLiability.value + account.money)
            }
            
            balance.accept(totalAssets.value + totalLiability.value)
        }
        if notIncludeTotalAccounts.count == 0 {
            sections.accept([AccountSectionModel(sectionTitle: R.string.localizable.joinTotal(), items: includeTotalAccounts)])
        } else {
            sections.accept([AccountSectionModel(sectionTitle: R.string.localizable.joinTotal(), items: includeTotalAccounts),
                             AccountSectionModel(sectionTitle: R.string.localizable.notJoinTotal(), items: notIncludeTotalAccounts)])
        }
    }

    func deleteAccount(_ accountlModel: AccountModel) {
        RealmManager.share.delete(accountlModel)
        getAccounts()
    }
    
}
