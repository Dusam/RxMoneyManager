//
//  HeaderViewModelType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

import Foundation

protocol HeaderViewModelType {
    var input: HeaderViewModel.Input! { get }
    var output: HeaderViewModel.Output! { get }
    
    func toPerviousDate()
    func toNextDate()
    func toCurrentDate()
    func toSelectedDate()
}
