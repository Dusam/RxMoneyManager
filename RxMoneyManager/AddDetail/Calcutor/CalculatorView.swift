//
//  CalculatorView.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CalculatorView: UIView {
    
    private var calcutorVM = CalculatorViewModel()
    private let disposeBag = DisposeBag()
    
    private let upRowButtons: [[CalcButton]] = [
        [.clear, .del, .divide, .multiply],
        [.seven, .eight, .nine, .subtract],
        [.four, .five, .six, .add]
    ]
    
    private let downRowButtons: [[CalcButton]] = [
        [.one, .two, .three],
        [.zero, .decimal]
    ]
    
    required init(addDetailVM: AddDetailViewModel) {
        super.init(frame: .zero)

        self.calcutorVM.amount = addDetailVM.amount
        self.calcutorVM.transferFee = addDetailVM.transferFee
        self.calcutorVM.isShowCalcutor = addDetailVM.isShowCalcutor
        self.setUpCalcutor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("CalculatorView deinit")
        #endif
    }
    
    private func setUpCalcutor() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 5
        
        addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        // 計算機上三排按鈕
        upRowButtons.forEach { buttons in
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 12
            stackView.distribution = .fillEqually
            
            buttons.forEach { button in
                let calcutorButton = CalculatorButton(button)
                stackView.addArrangedSubview(calcutorButton)
                calcutorButton.cornerRadius = buttonCornerRadius(item: button)
                
                calcutorButton.rx.tap.subscribe(onNext: { [weak self] _ in
                    self?.calcutorVM.buttonTap(button)
                })
                .disposed(by: disposeBag)
            }
            
            mainStackView.addArrangedSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.height.equalToSuperview().multipliedBy(0.19)
            }
        }
        
        // 計算機下二排按鈕
        let bottomStackView = UIStackView()
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.spacing = 12
        
        let bottomVStackView = UIStackView()
        bottomVStackView.axis = .vertical
        bottomVStackView.distribution = .fillEqually
        bottomVStackView.spacing = 5
        
        downRowButtons.forEach { buttons in
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 12
            stackView.distribution = .fillEqually
            
            buttons.forEach { button in
                if button == .zero {
                    stackView.distribution = .fill
                }
                let calcutorButton = CalculatorButton(button)
                stackView.addArrangedSubview(calcutorButton)
                calcutorButton.cornerRadius = buttonCornerRadius(item: button)
                
                if button == .zero {
                    calcutorButton.snp.makeConstraints { make in
                        make.width.equalToSuperview().multipliedBy(0.65)
                    }
                }
                
                calcutorButton.rx.tap.subscribe(onNext: { [weak self] _ in
                    self?.calcutorVM.buttonTap(button)
                })
                .disposed(by: disposeBag)
            }
            
            bottomVStackView.addArrangedSubview(stackView)
        }
        
        bottomStackView.addArrangedSubview(bottomVStackView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        // OK 按鈕
        let okButton = CalculatorButton(.ok)
        okButton.cornerRadius = buttonCornerRadius(item: .ok)
        bottomStackView.addArrangedSubview(okButton)
        okButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.22)
        }
        
        okButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.calcutorVM.buttonTap(.ok)
        })
        .disposed(by: disposeBag)
    }

    private func buttonCornerRadius(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4 * 12)) / 4) / 2.5
        }
        return ((UIScreen.main.bounds.width - ((3 * 12) + (2 * 5))) / 4) / 2.5
    }
    
    func setEditType(isEditAmount: Bool) {
        calcutorVM.setEditType(isEditAmount: isEditAmount)
    }
}
