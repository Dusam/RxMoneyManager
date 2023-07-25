//
//  CalculatorButton.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/30.
//

import UIKit

class CalculatorButton: UIButton {

    private var operation: CalcButton!
    
    required init(_ operation: CalcButton) {
        super.init(frame: .zero)
        
        self.operation = operation
        
        setTitle(operation.string, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 32)
        backgroundColor = operation.buttonColor
    }
    
    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                switch operation {
                case .subtract, .multiply, .divide, .ok, .clear, .del, .add:
                    backgroundColor = .darkGray
                default:
                    backgroundColor = .lightGray
                }
                
            } else {
                backgroundColor = operation.buttonColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
