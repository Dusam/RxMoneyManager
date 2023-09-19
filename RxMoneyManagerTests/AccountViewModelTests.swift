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
                    let totalAssetsObserver = scheduler.createObserver(String.self)
                    let totalLiabilityObserver = scheduler.createObserver(String.self)
                    let balanceObserver = scheduler.createObserver(String.self)
                    
                    viewModel.output.accountModels
                        .drive(accountModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalAssets
                        .drive(totalAssetsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalLiability
                        .drive(totalLiabilityObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.balance
                        .drive(balanceObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
//                    debugPrint(self, "accountModelsObserver: \(accountModelsObserver.events)")
                    expect(accountModelsObserver.events.first?.value.element).notTo(beNil())
                    expect(accountModelsObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(totalAssetsObserver.events.first?.value.element).to(equal("$0"))
                    expect(totalLiabilityObserver.events.first?.value.element).to(equal("$0"))
                    expect(balanceObserver.events.first?.value.element).to(equal("$0"))
                }
            }
            
            context("when load view") {
                it("when have detail data") {
                    let accountModelsObserver = scheduler.createObserver([AccountSectionModel].self)
                    let totalAssetsObserver = scheduler.createObserver(String.self)
                    let totalLiabilityObserver = scheduler.createObserver(String.self)
                    let balanceObserver = scheduler.createObserver(String.self)
                    
                    viewModel.output.accountModels
                        .drive(accountModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalAssets
                        .drive(totalAssetsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalLiability
                        .drive(totalLiabilityObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.balance
                        .drive(balanceObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.getAccounts()
                    
//                    debugPrint(self, "accountModelsObserver: \(accountModelsObserver.events)")
                    expect(accountModelsObserver.events.last?.value.element).notTo(beNil())
                    expect(accountModelsObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(totalAssetsObserver.events.last?.value.element).toNot(equal("$0"))
                    expect(totalLiabilityObserver.events.last?.value.element).toNot(equal("$0"))
                    expect(balanceObserver.events.last?.value.element).toNot(equal("$0"))
                    
                    // 測試新增一個未計入總計的帳戶，測試 getAccounts 方法的正確性
                    let addAccountViewModel = AddAccountViewModel()
                    scheduler.createColdObservable([.next(10, "安安你好")])
                        .bind(to: addAccountViewModel.input.accountName)
                        .disposed(by: disposeBag)
                    scheduler.createColdObservable([.next(20, false)])
                        .bind(to: addAccountViewModel.input.joinTotal)
                        .disposed(by: disposeBag)
                    scheduler.start()

                    addAccountViewModel.setAmount("150")
                    addAccountViewModel.setAccountType(.bank)
                    addAccountViewModel.setShowCalcutor(true)
                    addAccountViewModel.saveAccount()
                    
                    viewModel.getAccounts()
                    
                    // 刪除測試時新增的帳戶
                    viewModel.deleteAccount(RealmManager.share.getAccount().last!)
                    let accounts = RealmManager.share.getAccount()
                    expect(accounts.last?.name).toNot(equal("安安你好"))
                    expect(accounts.last?.initMoney).toNot(equal(150))
                    expect(accounts.last?.money).toNot(equal(150))
                    expect(accounts.last?.includTotal).toNot(beFalse())
                }
                
                it("when not have detail data") {
                    let accountModelsObserver = scheduler.createObserver([AccountSectionModel].self)
                    let totalAssetsObserver = scheduler.createObserver(String.self)
                    let totalLiabilityObserver = scheduler.createObserver(String.self)
                    let balanceObserver = scheduler.createObserver(String.self)
                    
                    viewModel.output.accountModels
                        .drive(accountModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalAssets
                        .drive(totalAssetsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalLiability
                        .drive(totalLiabilityObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.balance
                        .drive(balanceObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                                        
//                    debugPrint(self, "accountModelsObserver: \(accountModelsObserver.events)")
                    expect(accountModelsObserver.events.last?.value.element).notTo(beNil())
                    expect(accountModelsObserver.events.last?.value.element?.isEmpty).to(beTrue())
                    expect(totalAssetsObserver.events.last?.value.element).to(equal("$0"))
                    expect(totalLiabilityObserver.events.last?.value.element).to(equal("$0"))
                    expect(balanceObserver.events.last?.value.element).to(equal("$0"))
                }
                
                it("should have correct text color") {
                    let totalAssetsColorObserver = scheduler.createObserver(UIColor?.self)
                    let totalLiabilityColorObserver = scheduler.createObserver(UIColor?.self)
                    let balanceColorObserver = scheduler.createObserver(UIColor?.self)
                    
                    viewModel.output.totalAssetsColor
                        .drive(totalAssetsColorObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalLiabilityColor
                        .drive(totalLiabilityColorObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.balanceColor
                        .drive(balanceColorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(totalAssetsColorObserver.events.last?.value.element).to(equal(R.color.incomeColor()))
                    expect(totalLiabilityColorObserver.events.last?.value.element).to(equal(R.color.spendColor()))
                    expect(balanceColorObserver.events.last?.value.element).to(equal(R.color.incomeColor()))
                    
                    viewModel.getAccounts()
                    let addDetailVM = AddDetailViewModel()
                    
                    addDetailVM.setAmount("100000")
                    addDetailVM.saveDetail()
                    viewModel.getAccounts()
                    
                    expect(totalAssetsColorObserver.events.last?.value.element).to(equal(R.color.incomeColor()))
                    expect(totalLiabilityColorObserver.events.last?.value.element).to(equal(R.color.spendColor()))
                    expect(balanceColorObserver.events.last?.value.element).to(equal(R.color.spendColor()))
                    
                    // 刪除剛剛新增的
                    var details = RealmManager.share.readDetail(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"))
                    addDetailVM.setEditData(details.first!)
                    addDetailVM.delDetail()
                    details = RealmManager.share.readDetail(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"))
                    expect(details.count).to(equal(0))
                }
                
            }
        }
    }
}
