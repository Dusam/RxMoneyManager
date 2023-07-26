//
//  AccountViewModelType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

import Foundation

protocol AccountViewModelType {
    var input: AccountViewModel.Input! { get }
    var output: AccountViewModel.Output! { get }
    
    func getAccounts()
    func deleteAccount(_ accountlModel: AccountModel)
}
