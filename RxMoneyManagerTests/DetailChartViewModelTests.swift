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
                    let pieChartDataObserver = scheduler.createObserver(ChartData.self)
                    let totalObserver = scheduler.createObserver(String.self)
                    let chartDetailObserver = scheduler.createObserver([ChartDetailModel].self)
                    let chartSectionDatasObserver = scheduler.createObserver([ChartDetailSectionModel].self)
                    
                    viewModel.output.chartSegment
                        .drive(chartSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.currentDateString
                        .drive(currentDateStringObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.pieChartData
                        .drive(pieChartDataObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.total
                        .drive(totalObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.chartDetail
                        .drive(chartDetailObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.chartSectionDatas
                        .drive(chartSectionDatasObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(chartSegmentObserver.events.first?.value.element).to(equal(1))
                    expect(currentDateStringObserver.events.first?.value.element).to(equal(Date().string(withFormat: "yyyy-MM")))
                    expect(pieChartDataObserver.events.first?.value.element?.dataSetCount).to(equal(0))
                    expect(totalObserver.events.first?.value.element).to(equal("總計: $0"))
                    expect(chartDetailObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(chartSectionDatasObserver.events.first?.value.element?.isEmpty).to(beTrue())
                }
            }
            
            context("after initialized") {
                it("set chart by default value") {
                    let chartSegmentObserver = scheduler.createObserver(Int.self)
                    let currentDateStringObserver = scheduler.createObserver(String.self)
                    let pieChartDataObserver = scheduler.createObserver(ChartData.self)
                    let totalObserver = scheduler.createObserver(String.self)
                    let chartDetailObserver = scheduler.createObserver([ChartDetailModel].self)
                    let chartSectionDatasObserver = scheduler.createObserver([ChartDetailSectionModel].self)
                    
                    viewModel.output.chartSegment
                        .drive(chartSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.currentDateString
                        .drive(currentDateStringObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.pieChartData
                        .drive(pieChartDataObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.total
                        .drive(totalObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.chartDetail
                        .drive(chartDetailObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.chartSectionDatas
                        .drive(chartSectionDatasObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(chartSegmentObserver.events.first?.value.element).to(equal(1))
                    expect(currentDateStringObserver.events.first?.value.element).to(equal(Date().string(withFormat: "yyyy-MM")))
                    expect(pieChartDataObserver.events.first?.value.element?.dataSetCount).to(equal(0))
                    expect(totalObserver.events.first?.value.element).to(equal("總計: $0"))
                    expect(chartDetailObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(chartSectionDatasObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    
                    viewModel.setChart()
                    
                    expect(currentDateStringObserver.events.last?.value.element).to(equal(Date().string(withFormat: "yyyy-MM")))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(beGreaterThanOrEqualTo(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    expect(chartDetailObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(chartSectionDatasObserver.events.last?.value.element?.isEmpty).to(beTrue())
                }
                
                it("set chart by change month") {
                    let currentDateStringObserver = scheduler.createObserver(String.self)
                    let pieChartDataObserver = scheduler.createObserver(ChartData.self)
                    let totalObserver = scheduler.createObserver(String.self)
                   
                    viewModel.output.currentDateString
                        .drive(currentDateStringObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.pieChartData
                        .drive(pieChartDataObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.total
                        .drive(totalObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.toNext()
                    let currentMonth = Date().month
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023-\(String(format: "%02d", currentMonth + 1))"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    
                    viewModel.toPrevious()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023-\(String(format: "%02d", currentMonth))"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    
                    viewModel.toCurrentDate()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023-\(String(format: "%02d", currentMonth))"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                }
                
                it("set chart by change year") {
                    let chartSegmentObserver = scheduler.createObserver(Int.self)
                    let currentDateStringObserver = scheduler.createObserver(String.self)
                    let pieChartDataObserver = scheduler.createObserver(ChartData.self)
                    let totalObserver = scheduler.createObserver(String.self)
               
                    viewModel.output.chartSegment
                        .drive(chartSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.currentDateString
                        .drive(currentDateStringObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.pieChartData
                        .drive(pieChartDataObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.total
                        .drive(totalObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.setChartSegmentIndex(2)
                    viewModel.toNext()
                    let currentYear = 2023
                    expect(chartSegmentObserver.events.last?.value.element).to(equal(2))
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("\(currentYear + 1)"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    
                    viewModel.toPrevious()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("\(currentYear)"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(3))
                    expect(totalObserver.events.last?.value.element).toNot(equal("總計: $0"))
                    
                    viewModel.toPrevious()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("\(currentYear - 1)"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    
                    viewModel.toCurrentDate()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("\(currentYear)"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(3))
                    expect(totalObserver.events.last?.value.element).toNot(equal("總計: $0"))
                }
                
                it("set chart by change week") {
                    let chartSegmentObserver = scheduler.createObserver(Int.self)
                    let currentDateStringObserver = scheduler.createObserver(String.self)
                    let pieChartDataObserver = scheduler.createObserver(ChartData.self)
                    let totalObserver = scheduler.createObserver(String.self)
                    
                    viewModel.output.chartSegment
                        .drive(chartSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.currentDateString
                        .drive(currentDateStringObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.pieChartData
                        .drive(pieChartDataObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.output.total
                        .drive(totalObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.setChartSegmentIndex(0)
                    viewModel.toNext()
                    let currentWeek = Date().weekOfYear
                    expect(chartSegmentObserver.events.last?.value.element).to(equal(0))
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023(\(currentWeek + 1))"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    
                    viewModel.toPrevious()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023(\(currentWeek))"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    
                    viewModel.toPrevious()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023(\(currentWeek - 1))"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                    
                    viewModel.toCurrentDate()
                    expect(currentDateStringObserver.events.last?.value.element).to(equal("2023(\(currentWeek))"))
                    expect(pieChartDataObserver.events.last?.value.element?.dataSet(at: 0)?.entryCount).to(equal(1))
                    expect(totalObserver.events.last?.value.element).to(equal("總計: $0"))
                }
                
                it("set chart by billing type") {
                    let sectionDatasObserver = scheduler.createObserver([ChartDetailSectionModel].self)
                    viewModel.output.chartSectionDatas
                        .drive(sectionDatasObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.toPrevious()
                    viewModel.setChartDetailData(withBillingType: .income)
                    expect(sectionDatasObserver.events.last?.value.element?.first?.items).to(allPass({$0.billingType == BillingType.income.rawValue}))
                    
                    viewModel.setChartDetailData(withBillingType: .spend)
                    expect(sectionDatasObserver.events.last?.value.element?.first?.items).to(allPass({$0.billingType == BillingType.spend.rawValue}))
                    
                    viewModel.setChartDetailData(withBillingType: .transfer)
                    expect(sectionDatasObserver.events.last?.value.element?.first?.items).to(allPass({$0.billingType == BillingType.transfer.rawValue}))
                }
                
                it("if segment index not contains from DetailChartType") {
                    let chartSegmentObserver = scheduler.createObserver(Int.self)
                   
                    viewModel.output.chartSegment
                        .drive(chartSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.setChartSegmentIndex(5)
                    expect(chartSegmentObserver.events.last?.value.element).to(equal(1))
                }
            }
        }
    }
}
