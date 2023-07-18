//
//  AddAccountViewModelTests.swift
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

class AddAccountViewModelTests: QuickSpec {
    override class func spec() {
        describe("AddAccountViewModel") {
            var viewModel: AddAccountViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                viewModel = AddAccountViewModel()
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
                    let accountNameObserver = scheduler.createObserver(String.self)
                    let initAmountObserver = scheduler.createObserver(String.self)
                    let joinTotalObserver = scheduler.createObserver(Bool.self)
                    let isShowCalcutorObserver = scheduler.createObserver(Bool.self)
                    
                    viewModel.accountName
                        .drive(accountNameObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.initAmount
                        .drive(initAmountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.joinTotal
                        .drive(joinTotalObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.isShowCalcutor
                        .drive(isShowCalcutorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
//                    debugPrint(self, "accountNameObserver: \(accountNameObserver.events)")
                    expect(accountNameObserver.events.first?.value.element).to(equal(""))
                    expect(initAmountObserver.events.first?.value.element).to(equal("0"))
                    expect(joinTotalObserver.events.first?.value.element).to(beTrue())
                    expect(isShowCalcutorObserver.events.first?.value.element).to(beFalse())
                    expect(viewModel.type).to(equal(AccountType.cash))
                }
            }
            
            context("after initialized") {
                it("should have correct values after setting") {
                    let accountNameObserver = scheduler.createObserver(String.self)
                    let initAmountObserver = scheduler.createObserver(String.self)
                    let joinTotalObserver = scheduler.createObserver(Bool.self)
                    let isShowCalcutorObserver = scheduler.createObserver(Bool.self)
                    
                    viewModel.accountName
                        .drive(accountNameObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.initAmount
                        .drive(initAmountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.joinTotal
                        .drive(joinTotalObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.isShowCalcutor
                        .drive(isShowCalcutorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.setAccountName("安安你好")
                    viewModel.setAmount("150")
                    viewModel.setJoinTotal(false)
                    viewModel.setAccountType(.bank)
                    viewModel.setShowCalcutor(true)
                    viewModel.saveAccount()
                    
                    
                                        
//                    debugPrint(self, "accountNameObserver: \(accountNameObserver.events)")
                    expect(accountNameObserver.events.last?.value.element).to(equal("安安你好"))
                    expect(initAmountObserver.events.last?.value.element).to(equal("150"))
                    expect(joinTotalObserver.events.last?.value.element).to(beFalse())
                    expect(isShowCalcutorObserver.events.last?.value.element).to(beTrue())
                    expect(viewModel.type).to(equal(AccountType.bank))
                    expect(RealmManager.share.getAccount().last?.name).to(equal("安安你好"))
                    expect(RealmManager.share.getAccount().last?.initMoney).to(equal(150))
                    expect(RealmManager.share.getAccount().last?.money).to(equal(150))
                    expect(RealmManager.share.getAccount().last?.includTotal).to(beFalse())
                    expect(RealmManager.share.getAccount().last?.type).to(equal(AccountType.bank.typeInt))
                    
                    
                }
                
                it("when save account error") {
                    viewModel.setAccountName("")
                    viewModel.setAmount("")
                    viewModel.setJoinTotal(false)
                    viewModel.setAccountType(.bank)
                    viewModel.saveAccount()
                    
                    // 這邊取得最後一筆測試用的資料，以確定是否給予錯誤的資料時無法儲存
                    expect(RealmManager.share.getAccount().last?.name).to(equal("安安你好"))
                    expect(RealmManager.share.getAccount().last?.initMoney).to(equal(150))
                    expect(RealmManager.share.getAccount().last?.money).to(equal(150))
                    expect(RealmManager.share.getAccount().last?.includTotal).to(beFalse())
                    expect(RealmManager.share.getAccount().last?.type).to(equal(AccountType.bank.typeInt))
                    
                    // 刪除測試時新增的帳戶
                    let accountVM = AccountViewModel()
                    accountVM.deleteAccount(RealmManager.share.getAccount().last!)
                }
            }
        }
    }
}
