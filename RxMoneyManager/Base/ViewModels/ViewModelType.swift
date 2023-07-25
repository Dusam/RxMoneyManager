//
//  ViewModelType.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/19.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input! { get }
    var output: Output! { get }
}
