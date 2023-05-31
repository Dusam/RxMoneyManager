//
//  CalculatorViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/30.
//

import Foundation
import RxCocoa
import RxSwift
import SamUtils

class CalculatorViewModel {
    var amount = BehaviorRelay<String>(value: "0")
    var isShowCalcutor = BehaviorRelay<Bool>(value: false)
    
    private var amountString = "0"
    private var amountValue = 0.0
    private var currentOperation: Operation = .none
    
    func buttonTap(_ button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide:
            calculateAmount()
            
            currentOperation = button.operation
            
        case .ok:
            calculateAmount()
            currentOperation = .none
            amountValue = 0.0
            isShowCalcutor.accept(false)
            
        case .clear:
            amountString = "0"
            amountValue = 0.0
            
        case .del:
            if !amountString.isEmpty {
                amountString = amountString.substring(0, amountString.count - 1)
                
                if amountString.isEmpty {
                    amountString = "0"
                    amountValue = 0.0
                }
            }
        default:
            if amountString == "0" {
                amountString = button.string
            } else {
                amountString += button.string
            }
        }
        amount.accept(amountString)
    }
    
    private func calculateAmount() {
        guard currentOperation != .none && !amountString.isEmpty else { return }
        
        switch currentOperation {
        case .add:
            let array = amountString.split(separator: "+").compactMap { Double($0) }
            if array.count >= 2 {
                if amountValue == 0 {
                    amountValue = array[0]
                }
                
                amountValue += array[1]
                amountString = amountValue.clearZero
            } else {
                amountString = array[0].clearZero
            }
            
        case .subtract:
            let array = amountString.split(separator: "-").compactMap { Double($0) }
            if array.count >= 2 {
                if amountValue == 0 {
                    // 如果開頭是負值就加上負號
                    amountValue = amountString.first == "-" ? -(array[0]) : array[0]
                }
                
                amountValue -= array[1]
                amountString = amountValue.clearZero
            } else {
                amountString = array[0].clearZero
            }
            
        case .multiply:
            let array = amountString.split(separator: "x").compactMap { Double($0) }
            if array.count >= 2 {
                if amountValue == 0 {
                    amountValue = array[0]
                }
                
                amountValue *= array[1]
                amountString = amountValue.clearZero
            } else {
                amountString = array[0].clearZero
            }
            
        case .divide:
            let array = amountString.split(separator: "÷").compactMap { Double($0) }
            if array.count >= 2 {
                if amountValue == 0 {
                    amountValue = array[0]
                }
                
                amountValue /= array[1]
                amountString = amountValue.clearZero
            } else {
                amountString = array[0].clearZero
            }
            
        case .none:
            break
        }
    }
}
