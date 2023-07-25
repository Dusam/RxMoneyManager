//
//  DetailChartType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/7.
//

import Foundation

enum DetailChartType: Int, CaseIterable {
    case week = 0
    case month
    case year
    
    var name: String {
        switch self {
        case .week:
            return R.string.localizable.week()
        case .month:
            return R.string.localizable.month()
        case .year:
            return R.string.localizable.year()
        }
    }
    
    var calendarType: Calendar.Component {
        switch self {
        case .week:
            return .weekOfMonth
        case .month:
            return .month
        case .year:
            return .year
        }
    }
}
