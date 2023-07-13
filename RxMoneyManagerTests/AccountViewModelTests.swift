//
//  DetailViewModelTests.swift
//  RxMoneyManagerTests
//
//  Created by 杜千煜 on 2023/7/12.
//

import Quick
import Nimble
import RxTest

@testable import RxMoneyManager
@testable import RxSwift
@testable import RxCocoa

class AccountViewModelTests: QuickSpec {
    override class func spec() {
        describe("AccountViewModel") {
            var viewModel: AccountViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            beforeEach {
                viewModel = AccountViewModel()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }
            
            afterEach {
                viewModel = nil
                scheduler = nil
                disposeBag = nil
            }
            
            context("when initialized") {
                it("should have the correct initial values") {
                    let accountModelsObserver = scheduler.createObserver([AccountSectionModel].self)
                    let totalAssetsObserver = scheduler.createObserver(Int.self)
                    let totalLiabilityObserver = scheduler.createObserver(Int.self)
                    let balanceObserver = scheduler.createObserver(Int.self)
                    
                    viewModel.accountModels
                        .drive(accountModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalAssets
                        .drive(totalAssetsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalLiability
                        .drive(totalLiabilityObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.balance
                        .drive(balanceObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
//                    debugPrint(self, "accountModelsObserver: \(accountModelsObserver.events)")
                    expect(accountModelsObserver.events.first?.value.element).notTo(beNil())
                    expect(accountModelsObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(totalAssetsObserver.events.first?.value.element).to(equal(0))
                    expect(totalLiabilityObserver.events.first?.value.element).to(equal(0))
                    expect(balanceObserver.events.first?.value.element).to(equal(0))
                }
            }
            
            context("when load view") {
                it("when have detail data") {
                    let accountModelsObserver = scheduler.createObserver([AccountSectionModel].self)
                    let totalAssetsObserver = scheduler.createObserver(Int.self)
                    let totalLiabilityObserver = scheduler.createObserver(Int.self)
                    let balanceObserver = scheduler.createObserver(Int.self)
                    
                    viewModel.accountModels
                        .drive(accountModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalAssets
                        .drive(totalAssetsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalLiability
                        .drive(totalLiabilityObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.balance
                        .drive(balanceObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.getAccounts()
                    
//                    debugPrint(self, "accountModelsObserver: \(accountModelsObserver.events)")
                    expect(accountModelsObserver.events.last?.value.element).notTo(beNil())
                    expect(accountModelsObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(totalAssetsObserver.events.last?.value.element).toNot(equal(0))
                    expect(totalLiabilityObserver.events.last?.value.element).toNot(equal(0))
                    expect(balanceObserver.events.last?.value.element).toNot(equal(0))
                    
                    // 測試新增一個未計入總計的帳戶，測試 getAccounts 方法的正確性
                    let addAccountViewModel = AddAccountViewModel()
                    addAccountViewModel.setAccountName("安安你好")
                    addAccountViewModel.setAmount("150")
                    addAccountViewModel.setJoinTotal(false)
                    addAccountViewModel.setAccountType(.bank)
                    addAccountViewModel.setShowCalcutor(true)
                    addAccountViewModel.saveAccount()
                    
                    viewModel.getAccounts()
                    
                    viewModel.deleteAccount(RealmManager.share.getAccount().last!)
                    expect(RealmManager.share.getAccount().last?.name).toNot(equal("安安你好"))
                    expect(RealmManager.share.getAccount().last?.initMoney).toNot(equal(150))
                    expect(RealmManager.share.getAccount().last?.money).toNot(equal(150))
                    expect(RealmManager.share.getAccount().last?.includTotal).toNot(beFalse())
                }
                
                xit("when not have detail data") {
                    let accountModelsObserver = scheduler.createObserver([AccountSectionModel].self)
                    let totalAssetsObserver = scheduler.createObserver(Int.self)
                    let totalLiabilityObserver = scheduler.createObserver(Int.self)
                    let balanceObserver = scheduler.createObserver(Int.self)
                    
                    viewModel.accountModels
                        .drive(accountModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalAssets
                        .drive(totalAssetsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalLiability
                        .drive(totalLiabilityObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.balance
                        .drive(balanceObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.getAccounts()
                    
//                    debugPrint(self, "accountModelsObserver: \(accountModelsObserver.events)")
                    expect(accountModelsObserver.events.last?.value.element).notTo(beNil())
                    expect(accountModelsObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(totalAssetsObserver.events.last?.value.element).to(equal(0))
                    expect(totalLiabilityObserver.events.last?.value.element).to(equal(0))
                    expect(balanceObserver.events.last?.value.element).to(equal(0))
                }
            }
        }
    }
}
