//
//  DetailViewModelType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

import Foundation
import UIKit

protocol DetailViewModelType {
    var input: DetailViewModel.Input! { get }
    var output: DetailViewModel.Output! { get }
    
    func getDetail(_ date: String)
    func setThemeColor(_ color: UIColor)
}
