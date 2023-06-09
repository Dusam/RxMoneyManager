//
//  AddDetailViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/29.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
import SamUtils
import SnapKit

class AddDetailViewController: BaseViewViewController {
    
    enum AddDetailType {
        case add, edit
    }
    
    private let addDetailVM = AddDetailViewModel()
    private var calcutor: CalculatorView!
    
    private var amountView: UIView!
    private var amountTextField: UITextField!
    
    var addType: AddDetailType = .add
    var detailModel: DetailModel = DetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    deinit {
#if DEBUG
        print("AddDetailViewController deinit")
#endif
    }
    
    private func initView() {
        
        amountView = self.setUpAmountView()
        self.setUpSegment()
        self.createCalcutorView()
        self.bindCalcutorView()
        self.setUpHeaderView()
        
        if addType == .edit {
            addDetailVM.setEditData(detailModel)
        }
    }
}

// MARK: Amount
extension AddDetailViewController {
    private func setUpSegment() {
        let segment = UISegmentedControl()
        segment.segmentTitles = BillingType.allCases.map{ $0.name }
        segment.selectedSegmentIndex = 0
        
        segment.rx.selectedSegmentIndex
            .bind(to: addDetailVM.selectedSegmentRelay)
            .disposed(by: disposeBag)
        
        navigationItem.titleView = segment
        
        segment.snp.makeConstraints { make in
            make.width.equalTo(self.view.bounds.width * 0.6)
        }
        
        addDetailVM.selectedSegmentRelay
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let billType = BillingType(rawValue: selectedIndex) else { return }
                self?.amountTextField.textColor = billType.forgroundColor
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setUpAmountView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        let moneyTitleLabel = UILabel(text: "$TW")
        moneyTitleLabel.textColor = .blue
        moneyTitleLabel.font = .systemFont(ofSize: 26)
        
        amountTextField = UITextField()
        amountTextField.borderStyle = .none
        amountTextField.font = .systemFont(ofSize: 32)
        amountTextField.textAlignment = .right
        amountTextField.addBoard(.bottom, color: .blue, thickness: 1)
        
        stackView.addArrangedSubviews([moneyTitleLabel, amountTextField])
        
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.left.equalTo(safeAreaLayoutGuide).offset(10)
            make.right.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalTo(containerView)
            make.top.equalTo(containerView.snp.top).offset(10)
            make.bottom.equalTo(containerView.snp.bottom).offset(-10)
        }
        
        moneyTitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        // 綁定數字
        addDetailVM.amount
            .asDriver(onErrorJustReturn: "0")
            .drive(amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        amountTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.amountTextField.resignFirstResponder()
                self?.addDetailVM.setShowCalcutor(true)
            })
            .disposed(by: disposeBag)
        
        if addType == .add {
            amountTextField.becomeFirstResponder()
        }
        
        return containerView
    }
}


// MARK: Header
extension AddDetailViewController {
    private func setUpHeaderView() {
        let headerView = HeaderView(headerType: .addDetail)
        self.view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(amountView.snp.bottom)
            make.left.right.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
    }
}


// MARK: Calcutor
extension AddDetailViewController {
    private func createCalcutorView() {
        calcutor = CalculatorView(addDetailVM: addDetailVM)
        self.calcutor.isHidden = true
        self.view.addSubview(calcutor)
        
        calcutor.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
    
    private func bindCalcutorView() {
        addDetailVM.isShowCalcutor
            .subscribe(onNext: { [weak self] show in
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


// MARK: Spend
extension AddDetailViewController {
    private func setUpSpendView() {
        
    }
}
