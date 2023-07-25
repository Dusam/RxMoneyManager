//
//  CalcutorButton.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/30.
//

import Foundation
import UIKit

enum Operation {
    case add, subtract, multiply, divide, none
}

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "÷"
    case ok = "OK"
    case clear = "AC"
    case del = "DEL"
    case decimal = "."
    
    var buttonColor: UIColor {
        switch self {
        case .add, .subtract, .multiply, .divide, .ok:
            return .orange
        case .del:
            return .red
        case .clear:
            return .lightGray
        default:
            return UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1)
        }
    }
    
    var operation: Operation {
        switch self {
        case .add:
            return .add
        case .subtract:
            return .subtract
        case .multiply:
            return .multiply
        case .divide:
            return .divide
        default:
            return .none
        }
    }
    
    var string: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .zero:
            return "0"
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .multiply:
            return "x"
        case .divide:
            return "÷"
        case .ok:
            return "OK"
        case .clear:
            return "AC"
        case .del:
            return "DEL"
        case .decimal:
            return "."
        }
    }
}
