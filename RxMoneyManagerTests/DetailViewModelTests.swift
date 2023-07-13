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
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!

            beforeEach {
                viewModel = DetailViewModel()
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
                    let totalAmountObserver = scheduler.createObserver(Int.self)
                    let themeColorObserver = scheduler.createObserver(UIColor.self)
                    
                    viewModel.details
                        .drive(detailsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalAmount
                        .drive(totalAmountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.themeColor
                        .drive(themeColorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
//                    debugPrint(self, "detailsObserver: \(detailsObserver.events)")
                    expect(detailsObserver.events.first?.value.element?.isEmpty).to(beFalse())
                    expect(totalAmountObserver.events.first?.value.element).to(equal(0))
                    expect(themeColorObserver.events.first?.value.element).to(equal(UserInfo.share.themeColor))
                }
            }
            
            context("when have data initialized") {
                it("should have the correct values") {
                    let detailsObserver = scheduler.createObserver([DetailModel].self)
                    let totalAmountObserver = scheduler.createObserver(Int.self)
                    let themeColorObserver = scheduler.createObserver(UIColor.self)
                    
                    viewModel.details
                        .drive(detailsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.totalAmount
                        .drive(totalAmountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.themeColor
                        .drive(themeColorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.getDetail("2023-07-11")
                    
//                    debugPrint(self, "detailsObserver: \(detailsObserver.events)")
                    expect(detailsObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(totalAmountObserver.events.last?.value.element).toNot(equal(0))
                    expect(themeColorObserver.events.last?.value.element).to(equal(UserInfo.share.themeColor))
                }
            }
        }
    }
}
