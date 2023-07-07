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
    
    private var addAccountVM = AddAccountViewModel()
    
    private var accountTypeView: UIStackView!
    private var accountNameView: UIView!
    private var joinTotalView: UIStackView!
    
    private var typeButton: UIButton!
    private var accountNameTextField: UITextField!
    private var initAmountTextField: UITextField!
    private var joinTotalSwitch: UISwitch!
    
    private var calcutor: CalculatorView!
    
    private var saveButton: UIButton!
    
    override func setUpView() {
        setBackButton(title: R.string.localizable.addAccount())
        setUpAddAccountView()
        createCalcutorView()
    }
    
    override func bindUI() {
        bindButton()
        bindTextField()
        bindSwitch()
        bindCalcutorView()
    }
    
    override func viewWillLayoutSubviews() {
        accountTypeView.cornerRadius = 15
        accountNameView.cornerRadius = 15
        joinTotalView.cornerRadius = 15
        saveButton.cornerRadius = saveButton.width / 2
    }
    
    deinit {
        #if DEBUG
        print("AddAccountViewController deinit")
        #endif
    }
    
}

// MARK: SetUpView
extension AddAccountViewController {
    private func setUpAddAccountView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.left.top.equalTo(safeAreaLayoutGuide).offset(15)
            make.right.equalTo(safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.6)
        }
        
        setUpTypeButton()
        setUpAccountName()
        setUpIncludeTotal()
        setUpSaveButton()
        stackView.addArrangedSubviews([accountTypeView, accountNameView, joinTotalView])
        
        accountTypeView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        joinTotalView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    private func setUpTypeButton() {
        accountTypeView = UIStackView()
        accountTypeView.axis = .horizontal
        accountTypeView.distribution = .fill
        accountTypeView.spacing = 10
        accountTypeView.backgroundColor = .white
        accountTypeView.borderColor = .lightGray
        accountTypeView.borderWidth = 1
        
        let titleLabel = PaddingLabel()
        titleLabel.text = "帳戶類型:"
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.paddingLeft = 10
        
        typeButton = UIButton()
        typeButton.setTitle(AccountType.cash.typeName, for: .normal)
        typeButton.titleLabel?.font = .systemFont(ofSize: 20)
        typeButton.titleLabel?.textAlignment = .left
        typeButton.setTitleColor(R.color.transferColor(), for: .normal)
        typeButton.setTitleColor(.lightGray, for: .highlighted)
        
        accountTypeView.addArrangedSubviews([titleLabel, typeButton])
        
        typeButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func setUpAccountName() {
        accountNameView = UIView()
        accountNameView.backgroundColor = .white
        accountNameView.borderColor = .lightGray
        accountNameView.borderWidth = 1
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        let titleLabel = PaddingLabel()
        titleLabel.text = R.string.localizable.accountName()
        titleLabel.font = .systemFont(ofSize: 20)
        
        accountNameTextField = UITextField()
        accountNameTextField.font = .systemFont(ofSize: 20)
        accountNameTextField.borderStyle = .roundedRect
        
        let initAmountTitleLabel = PaddingLabel()
        initAmountTitleLabel.text = R.string.localizable.initialAmount()
        initAmountTitleLabel.font = .systemFont(ofSize: 20)
        
        initAmountTextField = UITextField()
        initAmountTextField.font = .systemFont(ofSize: 20)
        initAmountTextField.borderStyle = .roundedRect
        initAmountTextField.keyboardType = .asciiCapableNumberPad
        
        stackView.addArrangedSubviews([titleLabel, accountNameTextField, initAmountTitleLabel, initAmountTextField])
        accountNameView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
    }
    
    private func setUpIncludeTotal() {
        joinTotalView = UIStackView()
        joinTotalView.axis = .horizontal
        joinTotalView.distribution = .fill
        joinTotalView.spacing = 10
        joinTotalView.backgroundColor = .white
        joinTotalView.borderColor = .lightGray
        joinTotalView.borderWidth = 1
        
        let includeTitle = PaddingLabel()
        includeTitle.text = R.string.localizable.joinTotal()
        includeTitle.font = .systemFont(ofSize: 20)
        includeTitle.paddingLeft = 10
        
        let switchView = UIView()
        joinTotalSwitch = UISwitch()
        joinTotalSwitch.isOn = true
        
        switchView.addSubview(joinTotalSwitch)
        joinTotalSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        joinTotalView.addArrangedSubviews([includeTitle, switchView])
        
        includeTitle.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private func setUpSaveButton() {
        saveButton = UIButton()
        saveButton.tintColor = .white
        saveButton.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        saveButton.backgroundColor = .blue
        
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(saveButton.snp.height)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.15)
        }
    }
    
    private func createCalcutorView() {
        calcutor = CalculatorView(viewModel: addAccountVM)
        self.calcutor.isHidden = true
        self.view.addSubview(calcutor)
        
        calcutor.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
}


// MARK: BindUI
extension AddAccountViewController {
    private func bindButton() {
        typeButton.rx.tap.subscribe(onNext: { [weak self] in
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            for type in AccountType.allCases {
                actionSheet.addAction(UIAlertAction(title: type.typeName, style: .default) { [weak self] _ in
                    self?.addAccountVM.setAccountType(type)
                    self?.typeButton.setTitle(type.typeName, for: .normal)
                })
            }
            
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))
            
            self?.present(actionSheet, animated: true)
        })
        .disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.addAccountVM.saveAccount()
            self?.pop()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindTextField() {
        addAccountVM.accountName
            .drive(accountNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        accountNameTextField.rx.text.orEmpty
            .changed
            .subscribe(onNext: { [weak self] accountName in
                self?.addAccountVM.setAccountName(accountName)
            })
            .disposed(by: disposeBag)
        
        accountNameTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.addAccountVM.setShowCalcutor(false)
            })
            .disposed(by: disposeBag)
        
        
        addAccountVM.initAmount
            .drive(initAmountTextField.rx.text)
            .disposed(by: disposeBag)
        
        initAmountTextField.rx
            .controlEvent([.touchDown, .editingDidBegin])
            .subscribe(onNext: { [weak self] in
                self?.accountNameTextField.resignFirstResponder()
                self?.initAmountTextField.resignFirstResponder()
                self?.addAccountVM.setShowCalcutor(true)
                self?.calcutor.setEditType(isEditAmount: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSwitch() {
        addAccountVM.joinTotal
            .drive(joinTotalSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        joinTotalSwitch.rx.isOn
            .changed
            .subscribe(onNext: { [weak self] isOn in
                self?.addAccountVM.setJoinTotal(isOn)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCalcutorView() {
        addAccountVM.isShowCalcutor
            .drive(onNext: { [weak self] show in
                if show {
                    UIView.animate(withDuration: 0.3) {
                        self?.calcutor.isHidden = false
                        self?.calcutor.transform = CGAffineTransform(translationX: 0, y: 0)
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self?.calcutor.transform = CGAffineTransform(translationX: 0, y: 800)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
