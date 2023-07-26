//
//  AddAccountViewModelType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

import Foundation

protocol AddAccountViewModelType: CalculatorViewModelType {
    var input: AddAccountViewModel.Input! { get }
    var output: AddAccountViewModel.Output! { get }
    
    func setAccountType(_ type: AccountType)
    func saveAccount()
}
