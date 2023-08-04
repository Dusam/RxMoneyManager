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

@objc protocol CalculatorViewModelType {
    func setShowCalcutor(_ show: Bool)
    func setAmount(_ amountValue: String)
    @objc optional func setTransferFee(_ transferFeeValue: String)
}

class CalculatorViewModel {
    
    @Inject(name: "AddDetailViewModel") private var addDetailVM: CalculatorViewModelType
    @Inject(name: "AddAccountViewModel") private var addAccountVM: CalculatorViewModelType
    
    private(set) var amountString = "0"
    private(set) var amountValue = 0.0
    private(set) var transferString = "0"
    private(set) var transferValue = 0.0
    private(set) var currentOperation: Operation = .none
    private(set) var isEditAmount = true
    
    func buttonTap(_ button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide:
            if isEditAmount {
                calculateAmount()
                amountString += button.string
            } else {
                calculateTransferFee()
                transferString += button.string
            }
            
            currentOperation = button.operation
            
        case .ok:
            if isEditAmount {
                calculateAmount()
            } else {
                calculateTransferFee()
            }
            
            currentOperation = .none
            amountValue = 0.0
            transferValue = 0.0
            addDetailVM.setShowCalcutor(false)
            addAccountVM.setShowCalcutor(false)
            
        case .clear:
            if isEditAmount {
                amountString = "0"
                amountValue = 0.0
            } else {
                transferString = "0"
                transferValue = 0.0
            }
            
        case .del:
            if isEditAmount {
                if !amountString.isEmpty {
                    amountString = amountString.substring(0, amountString.count - 1)
                    
                    if amountString.isEmpty {
                        amountString = "0"
                        amountValue = 0.0
                    }
                }
            } else {
                if !transferString.isEmpty {
                    transferString = transferString.substring(0, transferString.count - 1)
                    
                    if transferString.isEmpty {
                        transferString = "0"
                        transferValue = 0.0
                    }
                }
            }
        default:
            if isEditAmount {
                if amountString == "0" {
                    amountString = button.string
                } else {
                    amountString += button.string
                }
            } else {
                if transferString == "0" {
                    transferString = button.string
                } else {
                    transferString += button.string
                }
            }
        }
        
        if isEditAmount {
            addDetailVM.setAmount(amountString)
            addAccountVM.setAmount(amountString)
        } else {
            addDetailVM.setTransferFee!(transferString)
        }
    }
    
    private func calculateAmount() {
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
    
    private func calculateTransferFee() {        
        switch currentOperation {
        case .add:
            let array = transferString.split(separator: "+").compactMap { Double($0) }
            if array.count >= 2 {
                if transferValue == 0 {
                    transferValue = array[0]
                }
                
                transferValue += array[1]
                transferString = transferValue.clearZero
            } else {
                transferString = array[0].clearZero
            }
            
        case .subtract:
            let array = transferString.split(separator: "-").compactMap { Double($0) }
            if array.count >= 2 {
                if transferValue == 0 {
                    // 如果開頭是負值就加上負號
                    transferValue = transferString.first == "-" ? -(array[0]) : array[0]
                }
                
                transferValue -= array[1]
                transferString = transferValue.clearZero
            } else {
                transferString = array[0].clearZero
            }
            
        case .multiply:
            let array = transferString.split(separator: "x").compactMap { Double($0) }
            if array.count >= 2 {
                if transferValue == 0 {
                    transferValue = array[0]
                }
                
                transferValue *= array[1]
                transferString = transferValue.clearZero
            } else {
                transferString = array[0].clearZero
            }
            
        case .divide:
            let array = transferString.split(separator: "÷").compactMap { Double($0) }
            if array.count >= 2 {
                if transferValue == 0 {
                    transferValue = array[0]
                }
                
                transferValue /= array[1]
                transferString = transferValue.clearZero
            } else {
                transferString = array[0].clearZero
            }
            
        case .none:
            break
        }
    }
    
    func setEditType(isEditAmount: Bool) {
        self.isEditAmount = isEditAmount
    }
}
