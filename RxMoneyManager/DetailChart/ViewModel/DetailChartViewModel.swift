//
//  DetailChartViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/7.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources
import SwifterSwift
import DGCharts

class DetailChartViewModel: BaseViewModel {
    
    struct ChartListData: Hashable {
        var billingType: BillingType
        var total: Int
        var percent: Double
    }
    
    private var pieChartDataEntrys: [PieChartDataEntry] = []
    
    private var startDate = Date()
    private var endDate = Date()
    
    private var chartType: DetailChartType = .month
    private let selectedSegmentRelay = BehaviorRelay<Int>(value: DetailChartType.month.rawValue)
    private(set) lazy var selectedSegment = selectedSegmentRelay.asDriver()
    
    private var currentDate: Date = Date().adding(.hour, value: 8) {
        didSet {
            setDateString()
        }
    }
    
    private let currentDateStringRelay = BehaviorRelay<String>(value: Date().string(withFormat: "yyyy-MM"))
    private(set) lazy var currentDateString = currentDateStringRelay.asDriver()
    
    // 數據參數
    private let chartListDatas = BehaviorRelay<[ChartListData]>(value: [])

    private let pieChartDataRelay = BehaviorRelay<PieChartData>(value: .init())
    private(set) lazy var pieChartData = pieChartDataRelay.asDriver()
    
    private let totalRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var total = totalRelay.asDriver()
    
    private let incomeTotalRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var incomeTotal = incomeTotalRelay.asDriver()
    
    private let spendTotalRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var expensesTotal = spendTotalRelay.asDriver()
    
    private let transferTotalRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var transferTotal = transferTotalRelay.asDriver()
    
   
    
    
    
    private let detailRelay = BehaviorRelay<[ChartDetailModel]>(value: [])
    private(set) lazy var detail = detailRelay.asDriver()
    
    private var incomeDatas: [DetailModel] = []
    private var spendDatas: [DetailModel] = []
    private var transferDatas: [DetailModel] = []
    
    private let chartSectionDatasRelay = BehaviorRelay<[ChartDetailSectionModel]>(value: [])
    private(set) lazy var chartSectionDatas = chartSectionDatasRelay.asDriver()
    
    override init() {
        super.init()
        
        getChartData()
    }
}

extension DetailChartViewModel {
    private func setSectionData(_ billingType: BillingType) {
        switch billingType {
        case .spend:
            chartSectionDatasRelay.accept(setSectionDatas(datas: spendDatas))
        case .income:
            chartSectionDatasRelay.accept(setSectionDatas(datas: incomeDatas))
        case .transfer:
            chartSectionDatasRelay.accept(setSectionDatas(datas: transferDatas))
        }
    }
    
    private func getChartData() {
        countDate()
        
        let data = RealmManager.share.searchDeatilWithDateRange(self.startDate, self.endDate)
        
        let totalAmount = data.reduce(0) { partialResult, model in
            partialResult + abs(model.amount)
        }
        
        incomeDatas = data.filter {BillingType(rawValue: $0.billingType) == .income}
        spendDatas = data.filter {BillingType(rawValue: $0.billingType) == .spend}
        transferDatas = data.filter {BillingType(rawValue: $0.billingType) == .transfer}
        
        incomeTotalRelay.accept(incomeDatas.reduce(0) { partialResult, model in
            partialResult + abs(model.amount)
        })
        
        spendTotalRelay.accept(spendDatas.reduce(0) { partialResult, model in
            partialResult + abs(model.amount)
        })
        
        transferTotalRelay.accept(transferDatas.reduce(0) { partialResult, model in
            partialResult + abs(model.amount)
        })
        
        totalRelay.accept(incomeTotalRelay.value - spendTotalRelay.value)
        let incomePercent = String(format: "%.2f", (incomeTotalRelay.value.double / totalAmount.double) * 100).double() ?? 0.0
        let spendPercent = String(format: "%.2f", (spendTotalRelay.value.double / totalAmount.double) * 100).double() ?? 0.0
        let transferPercent = String(format: "%.2f", (transferTotalRelay.value.double / totalAmount.double) * 100).double() ?? 0.0
        
        detailRelay.accept([ChartDetailModel(billingType: .income, percent: incomePercent, total: incomeTotalRelay.value, details: incomeDatas),
                            ChartDetailModel(billingType: .spend, percent: spendPercent, total: spendTotalRelay.value, details: spendDatas),
                            ChartDetailModel(billingType: .transfer, percent: transferPercent, total: transferTotalRelay.value, details: transferDatas)])
        
        chartListDatas.accept([ChartListData(billingType: .income, total: incomeTotalRelay.value, percent: incomePercent),
                               ChartListData(billingType: .spend, total: spendTotalRelay.value, percent: spendPercent),
                               ChartListData(billingType: .transfer, total: transferTotalRelay.value, percent: transferPercent)])
        
        if incomePercent > 0 || spendPercent > 0 || transferPercent > 0 {
            pieChartDataEntrys = [PieChartDataEntry(value: incomePercent, label: "\(incomePercent)%"),
                                  PieChartDataEntry(value: spendPercent, label: "\(spendPercent)%"),
                                  PieChartDataEntry(value: transferPercent, label: "\(transferPercent)%")]
        } else {
            pieChartDataEntrys = [PieChartDataEntry(value: 1, label: "")]
        }
        
        setChartData(pieChartDataEntrys)
    }
    
    private func setChartData(_ datas: [PieChartDataEntry]) {
        let data = PieChartData()
        let dataSet = PieChartDataSet(entries: datas)

        dataSet.label = ""
        dataSet.drawValuesEnabled = false
        dataSet.entryLabelFont = .systemFont(ofSize: 16)
        
        if datas.count <= 1 {
            dataSet.drawValuesEnabled = false
            dataSet.colors = [.gray]
        } else {
            dataSet.colors = [R.color.incomeColor()!,
                              R.color.spendColor()!,
                              R.color.transferColor()!]
        }
        
        data.dataSet = dataSet
        
        pieChartDataRelay.accept(data)
    }
    
    private func setDateString() {
        switch chartType {
        case .week:
            currentDateStringRelay.accept(currentDate.string(withFormat: "yyyy") + "(\(currentDate.weekOfYear))")
        case .month:
            currentDateStringRelay.accept(currentDate.string(withFormat: "yyyy-MM"))
        case .year:
            currentDateStringRelay.accept(currentDate.string(withFormat: "yyyy"))
        }
    }
    
    private func setSectionDatas(datas: [DetailModel]) -> [ChartDetailSectionModel] {
        var date = ""
        var dateDetails: [DetailModel] = []
        var sectionDatas: [ChartDetailSectionModel] = []

        datas.forEach { detail in
            if date != detail.date {
                if !date.isEmpty {
                    sectionDatas.append(ChartDetailSectionModel(sectionTitle: date, items: dateDetails))
                }
                dateDetails.removeAll()
                date = detail.date
            }
            dateDetails.append(detail)

            if let last = datas.last, last == detail {
                sectionDatas.append(ChartDetailSectionModel(sectionTitle: date, items: dateDetails))
            }
        }

        return sectionDatas
    }
}

// MARK: 切換月份
extension DetailChartViewModel {
    func toNext() {
        switch chartType {
        case .week:
            currentDate = currentDate.adding(.weekOfMonth, value: 1)
        case .month:
            currentDate = currentDate.adding(.month, value: 1)
        case .year:
            currentDate = currentDate.adding(.year, value: 1)
        }
        
        getChartData()
    }
    
    func toPrevious() {
        switch chartType {
        case .week:
            currentDate = currentDate.adding(.weekOfMonth, value: -1)
        case .month:
            currentDate = currentDate.adding(.month, value: -1)
        case .year:
            currentDate = currentDate.adding(.year, value: -1)
        }
        
        getChartData()
    }
    
    func toCurrentDate() {
        currentDate = Date()
        
        getChartData()
    }
    
    private func countDate() {
        var type: Calendar.Component = .month
        
        switch chartType {
        case .week:
            type = .weekOfMonth
        case .month:
            type = .month
        case .year:
            type = .year
        }
        
        if let startDate = currentDate.beginning(of: type)?.adding(.hour, value: 8),
           let endDate = currentDate.end(of: type)?.adding(.hour, value: 8) {
            self.startDate = startDate
            self.endDate = endDate
        }
    }
    
}


// MARK: Set Method
extension DetailChartViewModel {
    func setSegmentIndex(_ index: Int) {
        guard let type = DetailChartType(rawValue: index) else { return }
        chartType = type
        selectedSegmentRelay.accept(index)
        
        getChartData()
        setDateString()
    }
}

