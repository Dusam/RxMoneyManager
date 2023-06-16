//
//  AddAccountViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/16.
//

import UIKit
import SamUtils
import RxSwift
import RxCocoa
import SnapKit
import RxGesture

class AddAccountViewController: BaseViewController {

    override func initView() {
        setBackButton(title: R.string.localizable.addAccount())
        setUpView()
    }

    
}

extension AddAccountViewController {
    private func setUpView() {
        func setUpTypeButton() -> UIButton {
            let button = UIButton()
            button.setTitle(AccountType.cash.typeName, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.setTitleColor(R.color.transferColor(), for: .normal)
            button.setTitleColor(.lightGray, for: .highlighted)
            
            button.rx.tap.subscribe(onNext: {
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                for type in AccountType.allCases {
                    actionSheet.addAction(UIAlertAction(title: type.typeName, style: .default) {_ in
                        button.setTitle(type.typeName, for: .normal)
                    })
                }
                
                actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))
                
                self.present(actionSheet, animated: true)
            })
            .disposed(by: disposeBag)
            
            return button
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.left.top.equalTo(safeAreaLayoutGuide).offset(15)
            make.right.equalTo(safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.7)
        }
        
        let accountTypeButton = setUpTypeButton()
        stackView.addArrangedSubviews([accountTypeButton])
    }
}
