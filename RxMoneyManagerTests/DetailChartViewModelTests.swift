//
//  DetailChartViewModelTests.swift
//  RxMoneyManagerTests
//
//  Created by 杜千煜 on 2023/7/14.
//

import Quick
import Nimble
import RxTest

@testable import RxMoneyManager
@testable import RxSwift
@testable import RxCocoa
@testable import DGCharts


class DetailChartViewModelTests: QuickSpec {
    override class func spec() {
        describe("DetailChartViewModel") {
            var viewModel: DetailChartViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                viewModel = DetailChartViewModel()
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
                    let chartSegmentObserver = scheduler.createObserver(Int.self)
                    let currentDateStringObserver = scheduler.createObserver(String.self)
                    let pieChartDataObserver = scheduler.createObserver(PieChartData.self)
                    let totalObserver = scheduler.createObserver(Int.self)
                    let chartDetailObserver = scheduler.createObserver([ChartDetailModel].self)
                    let chartSectionDatasObserver = scheduler.createObserver([ChartDetailSectionModel].self)
                    
                    viewModel.chartSegment
                        .drive(chartSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.currentDateString
                        .drive(currentDateStringObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.pieChartData
                        .drive(pieChartDataObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.total
                        .drive(totalObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.chartDetail
                        .drive(chartDetailObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.chartSectionDatas
                        .drive(chartSectionDatasObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(chartSegmentObserver.events.first?.value.element).to(equal(1))
                    expect(currentDateStringObserver.events.first?.value.element).to(equal("2023-07"))
                    expect(pieChartDataObserver.events.first?.value.element?.dataSetCount).to(equal(0))
                    expect(totalObserver.events.first?.value.element).to(equal(0))
                    expect(chartDetailObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(chartSectionDatasObserver.events.first?.value.element?.isEmpty).to(beTrue())
                }
            }
            
            context("after initialized") {
                it("set chart by default value") {
                    let chartSegmentObserver = scheduler.createObserver(Int.self)
                    let currentDateStringObserver = scheduler.createObserver(String.self)
                    let pieChartDataObserver = scheduler.createObserver(PieChartData.self)
                    let totalObserver = scheduler.createObserver(Int.self)
                    let chartDetailObserver = scheduler.createObserver([ChartDetailModel].self)
                    let chartSectionDatasObserver = scheduler.createObserver([ChartDetailSectionModel].self)
                    
                    viewModel.chartSegment
                        .drive(chartSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.currentDateString
                        .drive(currentDateStringObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.pieChartData
                        .drive(pieChartDataObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.total
                        .drive(totalObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.chartDetail
                        .drive(chartDetailObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.chartSectionDatas
                        .drive(chartSectionDatasObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(chartSegmentObserver.events.first?.value.element).to(equal(1))
                    expect(currentDateStringObserver.events.first?.value.element).to(equal("2023-07"))
                    expect(pieChartDataObserver.events.first?.value.element?.dataSetCount).to(equal(0))
                    expect(totalObserver.events.first?.value.element).to(equal(0))
                    expect(chartDetailObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(chartSectionDatasObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    
                    viewModel.setChart()
                    
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023-07"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSetCount).to(beGreaterThanOrEqualTo(1))
                    expect(totalObserver.events.last?.value.element).toNot(equal(0))
                    expect(chartDetailObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(chartSectionDatasObserver.events.last?.value.element?.isEmpty).to(beFalse())
                }
            }
        }
    }
}
