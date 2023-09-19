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

class DetailViewModelTests: QuickSpec {
    override class func spec() {
        describe("DetailViewModel") {
            var viewModel: DetailViewModel!
            var addDetailViewModel: AddDetailViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            beforeEach {
                viewModel = DetailViewModel()
                addDetailViewModel = AddDetailViewModel()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }
            
            afterEach {
                viewModel = nil
                scheduler = nil
                disposeBag = nil
            }
            
            context("when not have data initialized") {
                it("should have the correct initial values") {
                    let detailsObserver = scheduler.createObserver([DetailModel].self)
                    let totalAmountObserver = scheduler.createObserver(String.self)
                    let themeColorObserver = scheduler.createObserver(UIColor.self)
                    
                    viewModel.output.details
                        .drive(detailsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalAmount
                        .drive(totalAmountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.themeColor
                        .drive(themeColorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    debugPrint(self, "detailsObserver: \(detailsObserver.events)")
                    expect(detailsObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(totalAmountObserver.events.first?.value.element).to(equal("$TW 0"))
                    expect(themeColorObserver.events.first?.value.element).to(equal(UserInfo.share.themeColor))
                }
            }
            
            context("when have data initialized") {
                it("should have the correct values") {
                    let detailsObserver = scheduler.createObserver([DetailModel].self)
                    let totalAmountObserver = scheduler.createObserver(String.self)
                    let themeColorObserver = scheduler.createObserver(UIColor.self)
                    
                    viewModel.output.details
                        .drive(detailsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.totalAmount
                        .drive(totalAmountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.themeColor
                        .drive(themeColorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    addDetailViewModel.setBillingType(.income)
                    addDetailViewModel.setAmount("1000")
                    UserInfo.share.selectedDate = "2023-07-11".toDate()
                    addDetailViewModel.saveDetail()
                    
                    viewModel.getDetail("2023-07-11")
                    
                    addDetailViewModel.setEditData(RealmManager.share.readDetail("2023-07-11").last!)
                    addDetailViewModel.delDetail()
                    
//                    debugPrint(self, "detailsObserver: \(detailsObserver.events)")
                    expect(detailsObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(totalAmountObserver.events.last?.value.element).toNot(equal("$TW 0"))
                    expect(themeColorObserver.events.last?.value.element).to(equal(UserInfo.share.themeColor))
                    
                    // 設定主題顏色
                    viewModel.setThemeColor(.blue)
                    expect(themeColorObserver.events.last?.value.element).to(equal(.blue))
                }
                
            }
        }
    }
}
