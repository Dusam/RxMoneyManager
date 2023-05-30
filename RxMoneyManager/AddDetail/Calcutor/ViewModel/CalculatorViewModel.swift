//
//  CalculatorViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/30.
//

import Foundation
import RxCocoa
import RxSwift

class CalculatorViewModel {
    var amount = BehaviorRelay<String>(value: "0")
    var isShowCalcutor = BehaviorRelay<Bool>(value: false)
    
    private var amountString = ""
    private var currentOperation: Operation = .none
    
    func buttonTap(_ button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide:
            currentOperation = button.operation
            // TODO: 計算數值
        case .ok:
            amountString = ""
            isShowCalcutor.accept(false)
        case .clear:
            amountString = "0"
        case .del:
            amountString = amountString.substring(0, amountString.count - 1)
        default:
            amountString += button.string
        }
        amount.accept(amountString)
    }
    
    private func calculateAmount() {
        
    }
}
