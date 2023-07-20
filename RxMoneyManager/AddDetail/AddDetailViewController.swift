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

class AddDetailViewController: BaseViewController {
    
    enum AddDetailType {
        case add, edit
    }
    
    private let addDetailVM = AddDetailViewModel()
    private var calcutor: CalculatorView!
    
    private var typeSegment: UISegmentedControl!
    private var amountView: UIView!
    private var amountTextField: UITextField!
    private var headerView: HeaderView!
    private var detailTableView: UITableView!
    private var saveButton: UIButton!
    private var delButton: UIButton!
    
    var addType: AddDetailType = .add
    var detailModel: DetailModel = DetailModel()
    
    override func setUpView() {
        setBackButton(title: "新增明細")
        amountView = self.setUpAmountView()
        setUpSegment()
        setUpHeaderView()
        setUpAddDetailView()
        setUpButton()
        createCalcutorView()
    }
    
    override func bindUI() {
        bindCalcutorView()
        bindTypeSegment()
        bindAmountTextField()
        bindDetailTableView()
        bindButtons()
        
        if addType == .edit {
            addDetailVM.setEditData(detailModel)
        }
    }
    
    deinit {
        #if DEBUG
        print("AddDetailViewController deinit")
        #endif
    }
}

// MARK: SetUpAmount
extension AddDetailViewController {
    private func setUpSegment() {
        typeSegment = UISegmentedControl()
        typeSegment.segmentTitles = BillingType.allCases.map{ $0.name }
        typeSegment.selectedSegmentIndex = 0
        typeSegment.backgroundColor = UserInfo.share.themeColor.isLight ? .white : UserInfo.share.themeColor
        typeSegment.selectedSegmentTintColor = UserInfo.share.themeColor.isLight ? UserInfo.share.themeColor : .white
        typeSegment.setTitleTextAttributes([.foregroundColor: UserInfo.share.themeColor.isLight ? UIColor.white : UIColor.black], for: .selected)
        typeSegment.setTitleTextAttributes([.foregroundColor: UserInfo.share.themeColor.isLight ? UIColor.black : UIColor.white], for: .normal)
        
        navigationItem.titleView = typeSegment
        
        typeSegment.snp.makeConstraints { make in
            make.width.equalTo(self.view.bounds.width * 0.6)
        }
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
        amountTextField.addBoard(.bottom, color: .lightGray, thickness: 1)
        
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
        
        
        
        return containerView
    }
}

// MARK: BindAmount
extension AddDetailViewController {
    private func bindTypeSegment() {
        typeSegment.rx.selectedSegmentIndex
            .changed
            .bind(to: addDetailVM.input.billingSegment)
//            .subscribe(onNext: { [weak self] selectedIndex in
//                self?.addDetailVM.setBillingSegmentIndex(selectedIndex)
//            })
            .disposed(by: disposeBag)
        
        addDetailVM.output.billingSegment
            .drive(onNext: { [weak self] selectedIndex in
                guard let billType = BillingType(rawValue: selectedIndex) else { return }
                self?.addDetailVM.setBillingType(billType)
                self?.amountTextField.textColor = billType.forgroundColor
                // 編輯時也需要依照選擇的項目同步選擇的項目
                self?.typeSegment.selectedSegmentIndex = selectedIndex
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAmountTextField() {
        // 綁定數字
        addDetailVM.output.amount
            .drive(amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        amountTextField.rx
            .controlEvent(.editingDidBegin)
            .map { return true }
            .bind(to: addDetailVM.input.isShowCalcutor)
//            .subscribe(onNext: { [weak self] in
//                self?.amountTextField.resignFirstResponder()
//                self?.setShowCalcutor(true)
//                self?.calcutor.setEditType(isEditAmount: true)
//            })
            .disposed(by: disposeBag)
        
        if addType == .add {
            amountTextField.becomeFirstResponder()
        }
    }
}


// MARK: Header
extension AddDetailViewController {
    private func setUpHeaderView() {
        headerView = HeaderView(headerType: .addDetail)
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
        calcutor = CalculatorView(viewModel: addDetailVM)
        self.calcutor.isHidden = true
        self.view.addSubview(calcutor)
        
        calcutor.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
    
    private func bindCalcutorView() {
        addDetailVM.output.isShowCalcutor
            .drive(onNext: { [weak self] show in
                if show {
                    self?.amountTextField.resignFirstResponder()
                    self?.calcutor.setEditType(isEditAmount: true)
                    
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
    
//    private func setShowCalcutor(_ show: Bool) {
//        if !show {
//            amountTextField.resignFirstResponder()
//        }
//        self.addDetailVM.setShowCalcutor(show)
//
//    }
}


// MARK: AddDetailView
extension AddDetailViewController {
    private func setUpAddDetailView() {
        detailTableView = UITableView()
        view.addSubview(detailTableView)
        
        detailTableView.register(cellWithClass: AddDetailCell.self)
        detailTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bindDetailTableView() {
        addDetailVM.output.addDetailViewCells
            .drive(detailTableView.rx.items(cellIdentifier: "AddDetailCell", cellType: AddDetailCell.self)) { [weak self] row, value, cell in
                cell.disposeBag = DisposeBag()
                
                cell.addTitleLabel.text = value
                cell.accessoryType = .disclosureIndicator
                
                switch self?.typeSegment.selectedSegmentIndex {
                case 0:
                    self?.setUpSpendCell(row, cell)
                case 1:
                    self?.setUpIncomeCell(row, cell)
                case 2:
                    self?.setUpTransferCell(row, cell)
                default:
                    break
                }
                
            }
            .disposed(by: disposeBag)
        
        detailTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.addDetailVM.setShowCalcutor(false)
            
            if self?.typeSegment.selectedSegmentIndex == 2 {
                
                switch indexPath.row {
                case 0:
                    // 選擇帳戶
                    let vc = ChooseAccountViewController(.normal, addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 1:
                    // 選擇帳戶
                    let vc = ChooseAccountViewController(.transfer, addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 2:
                    // 轉帳手續費
                    self?.addDetailVM.setShowCalcutor(true)
                    self?.calcutor.setEditType(isEditAmount: false)
                    
                case 3:
                    let vc = ChooseTypeViewController(addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 4:
                    let vc = MemoViewController(addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                default:
                    break
                }
                
            } else {
                
                switch indexPath.row {
                case 0:
                    let vc = ChooseTypeViewController(addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 1:
                    // 選擇帳戶
                    let vc = ChooseAccountViewController(.normal, addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 2:
                    // 填寫備註
                    let vc = MemoViewController(addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                default:
                    break
                }
                
            }
            
            self?.detailTableView.deselectRow(at: indexPath, animated: true)
            
        }).disposed(by: disposeBag)
    }
    
    private func setUpSpendCell(_ row: Int, _ cell: AddDetailCell) {
        cell.typeLabel.textColor = R.color.spendColor()
        
        if row == 0 {
            self.addDetailVM.output.typeName
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        }
        
        if row == 1 {
            self.addDetailVM.output.accountName
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        }
        
        if row == 2 {
            self.addDetailVM.output.memo
                .map{ $0.replacingOccurrences(of: "\n", with: " ")}
                .drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        }
    }
    
    private func setUpIncomeCell(_ row: Int, _ cell: AddDetailCell) {
        cell.typeLabel.textColor = R.color.incomeColor()
        
        if row == 0 {
            self.addDetailVM.output.typeName
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        }
        
        if row == 1 {
            self.addDetailVM.output.accountName
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        }
        
        if row == 2 {
            self.addDetailVM.output.memo
                .map{ $0.replacingOccurrences(of: "\n", with: " ")}
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        }
    }
    
    private func setUpTransferCell(_ row: Int, _ cell: AddDetailCell) {
        cell.typeLabel.textColor = R.color.transferColor()
        
        switch row {
        case 0:
            self.addDetailVM.output.accountName
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        case 1:
            self.addDetailVM.output.toAccountName
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        case 2:
            cell.accessoryType = .none
            self.addDetailVM.output.transferFee
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        case 3:
            self.addDetailVM.output.typeName
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        case 4:
            self.addDetailVM.output.memo
                .map{ $0.replacingOccurrences(of: "\n", with: " ")}
                .drive(cell.typeLabel.rx.text)
                .disposed(by: cell.disposeBag)
        default:
            break
        }
        
    }
    
    private func setUpButton() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
        
        saveButton = UIButton()
        saveButton.setTitle(R.string.localizable.save(), for: .normal)
        saveButton.setTitleColor(R.color.transferColor(), for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 20)
        
        
        delButton = UIButton()
        delButton.setTitle(R.string.localizable.delete(), for: .normal)
        delButton.setTitleColor(R.color.spendColor(), for: .normal)
        delButton.titleLabel?.font = .systemFont(ofSize: 20)
        
        stackView.addArrangedSubviews([delButton, saveButton])
        
        if addType == .add {
            delButton.isHidden = true
        }
    }
    
    private func bindButtons() {
        saveButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.addDetailVM.saveDetail()
            self?.pop()
        })
        .disposed(by: disposeBag)
        
        delButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.addDetailVM.delDetail()
            self?.pop()
        })
        .disposed(by: disposeBag)
    }
}
