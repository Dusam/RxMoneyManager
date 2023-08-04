//
//  DetailChartViewModelType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

import Foundation

protocol DetailChartViewModelType {
    var input: DetailChartViewModel.Input! { get }
    var output: DetailChartViewModel.Output! { get }
    var billingType: BillingType { get }
    
    func setChart()
    func setChartDetailData(withBillingType: BillingType)
    
    func toNext()
    func toPrevious()
    func toCurrentDate()
    func setChartSegmentIndex(_ index: Int)
}
