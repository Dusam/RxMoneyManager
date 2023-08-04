//
//  HeaderViewModelTests.swift
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

class HeaderViewModelTest: QuickSpec {
    override class func spec() {
        describe("HeaderViewModel") {
            var viewModel: HeaderViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                viewModel = HeaderViewModel(headerType: .detail, detailVM: DetailViewModel())
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
                    let currentDateObserver = scheduler.createObserver(String.self)
                    
                    viewModel.output.currentDate
                        .drive(currentDateObserver)
                        .disposed(by: disposeBag)
                  
                    scheduler.start()
                    
//                    debugPrint(self, "currentDateObserver: \(currentDateObserver.events)")
                    expect(currentDateObserver.events.first?.value.element).to(equal(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)")))
                }
                
                it("change date method") {
                    let currentDateObserver = scheduler.createObserver(String.self)
                    
                    viewModel.output.currentDate
                        .drive(currentDateObserver)
                        .disposed(by: disposeBag)
                  
                    scheduler.start()
                    
                    viewModel.toPerviousDate()
                    expect(currentDateObserver.events.last?.value.element).to(equal(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)")))
                    
                    viewModel.toCurrentDate()
                    expect(currentDateObserver.events.last?.value.element).to(equal(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)")))
                    
                    viewModel.toNextDate()
                    expect(currentDateObserver.events.last?.value.element).to(equal(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)")))
                    
                    UserInfo.share.selectedDate = "2023-10-11".toDate()
                    viewModel.toSelectedDate()
                    expect(currentDateObserver.events.last?.value.element).to(equal("2023-10-11(週三)"))
                }
            }
        }
    }
}
