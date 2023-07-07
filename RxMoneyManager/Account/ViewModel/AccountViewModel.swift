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
    
    private let accountModelsRelay = BehaviorRelay<[AccountSectionModel]>(value: [])
    private(set) lazy var accountModels = accountModelsRelay.asDriver()
    
    private let totalAssetsRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var totalAssets = totalAssetsRelay.asDriver()
    
    private let totalLiabilityRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var totalLiability = totalLiabilityRelay.asDriver()
    
    private let balanceRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var balance = balanceRelay.asDriver()
    
    private var includeTotalAccounts: [AccountModel] = []
    private var notIncludeTotalAccounts: [AccountModel] = []
}

extension AccountViewModel {
    func getAccounts() {
        totalAssetsRelay.accept(0)
        totalLiabilityRelay.accept(0)
        balanceRelay.accept(0)
        includeTotalAccounts.removeAll()
        notIncludeTotalAccounts.removeAll()
        
        let accounts = RealmManager.share.getAccount()
        
        includeTotalAccounts = accounts.filter { $0.includTotal }
        notIncludeTotalAccounts = accounts.filter { !$0.includTotal}
        
        includeTotalAccounts.forEach { account in
            if account.money >= 0 {
                totalAssetsRelay.accept(totalAssetsRelay.value + account.money)
            } else {
                totalLiabilityRelay.accept(totalLiabilityRelay.value + account.money)
            }
            
            balanceRelay.accept(totalAssetsRelay.value + totalLiabilityRelay.value)
        }
        if notIncludeTotalAccounts.count == 0 {
            accountModelsRelay.accept([AccountSectionModel(sectionTitle: R.string.localizable.joinTotal(), items: includeTotalAccounts)])
        } else {
            accountModelsRelay.accept([AccountSectionModel(sectionTitle: R.string.localizable.joinTotal(), items: includeTotalAccounts),
                                       AccountSectionModel(sectionTitle: R.string.localizable.notJoinTotal(), items: notIncludeTotalAccounts)])
        }
    }
    
    func deleteAccount(_ accountlModel: AccountModel) {
        RealmManager.share.delete(accountlModel)
        getAccounts()
    }
    
}
