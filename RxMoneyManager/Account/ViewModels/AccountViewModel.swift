//
//  AccountViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/26.
//

import Foundation
import RxCocoa
import RxSwift

class AccountViewModel: AccountViewModelType {
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let accountModels = BehaviorRelay<[AccountSectionModel]>(value: [])
    private let totalAssets = BehaviorRelay<Int>(value: 0)
    private let totalLiability = BehaviorRelay<Int>(value: 0)
    private let balance = BehaviorRelay<Int>(value: 0)
    
    private var includeTotalAccounts: [AccountModel] = []
    private var notIncludeTotalAccounts: [AccountModel] = []
    
    init() {
        
        let totalAssetsColor = totalAssets.map { _ in
            R.color.incomeColor()
        }.asDriver(onErrorJustReturn: R.color.incomeColor())
        
        let totalLiabilityColor = totalLiability.map {_ in
            R.color.spendColor()
        }.asDriver(onErrorJustReturn: R.color.spendColor())
        
        let balanceColor = balance.map {
            $0 >= 0 ? R.color.incomeColor() : R.color.spendColor()
        }.asDriver(onErrorJustReturn: R.color.incomeColor())
        
        input = .init()
        output = .init(accountModels: accountModels.asDriver(),
                       totalAssets: totalAssets.map { "$\($0)" }.asDriver(onErrorJustReturn: ""),
                       totalLiability: totalLiability.map { "$\($0)" }.asDriver(onErrorJustReturn: ""),
                       balance: balance.map { "$\($0)" }.asDriver(onErrorJustReturn: ""),
                       totalAssetsColor: totalAssetsColor,
                       totalLiabilityColor: totalLiabilityColor,
                       balanceColor: balanceColor)
    }
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
            accountModels.accept([AccountSectionModel(sectionTitle: R.string.localizable.joinTotal(), items: includeTotalAccounts)])
        } else {
            accountModels.accept([AccountSectionModel(sectionTitle: R.string.localizable.joinTotal(), items: includeTotalAccounts),
                                       AccountSectionModel(sectionTitle: R.string.localizable.notJoinTotal(), items: notIncludeTotalAccounts)])
        }
    }
    
    func deleteAccount(_ accountlModel: AccountModel) {
        RealmManager.share.delete(accountlModel)
        getAccounts()
    }
    
}

extension AccountViewModel {
    struct Input {
        
    }
    
    struct Output {
        let accountModels: Driver<[AccountSectionModel]>
        let totalAssets: Driver<String>
        let totalLiability: Driver<String>
        let balance: Driver<String>
        let totalAssetsColor: Driver<UIColor?>
        let totalLiabilityColor: Driver<UIColor?>
        let balanceColor: Driver<UIColor?>
    }
}
