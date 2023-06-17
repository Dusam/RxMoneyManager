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
    
    private var amountView: UIView!
    private var amountTextField: UITextField!
    private var headerView: HeaderView!
    
    var addType: AddDetailType = .add
    var detailModel: DetailModel = DetailModel()
    
    override func initView() {
        amountView = self.setUpAmountView()
        self.setUpSegment()
        self.setUpHeaderView()
        self.setUpAddDetailView()
        self.setUpButton()
        self.createCalcutorView()
        self.bindCalcutorView()
        
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
        
        // 編輯時也需要依照選擇的項目同步選擇的項目
        addDetailVM.selectedSegmentRelay
            .bind(to: segment.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        addDetailVM.selectedSegmentRelay
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let billType = BillingType(rawValue: selectedIndex) else { return }
                self?.addDetailVM.setBillingType(billType)
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
        
        // 綁定數字
        addDetailVM.amount
            .asDriver(onErrorJustReturn: "0")
            .drive(amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        amountTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.amountTextField.resignFirstResponder()
                self?.setShowCalcutor(true)
                self?.calcutor.setEditType(isEditAmount: true)
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
    
    private func setShowCalcutor(_ show: Bool) {
        if !show {
            amountTextField.resignFirstResponder()
        }
        self.addDetailVM.setShowCalcutor(show)
        
    }
}


// MARK: AddDetailView
extension AddDetailViewController {
    private func setUpAddDetailView() {
        let tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.register(cellWithClass: AddDetailCell.self)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        addDetailVM.addDetailCellModels
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: "AddDetailCell", cellType: AddDetailCell.self)) { [weak self] row, value, cell in
                cell.disposeBag = DisposeBag()
                
                cell.addTitleLabel.text = value
                cell.accessoryType = .disclosureIndicator
                
                switch self?.addDetailVM.selectedSegmentRelay.value {
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
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            
            if self?.addDetailVM.selectedSegmentRelay.value == 2 {
                
                switch indexPath.row {
                case 0:
                    // 選擇帳戶
                    self?.setShowCalcutor(false)
                    let vc = ChooseAccountViewController(.normal, addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 1:
                    // 選擇帳戶
                    self?.setShowCalcutor(false)
                    let vc = ChooseAccountViewController(.transfer, addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 2:
                    // 轉帳手續費
                    self?.setShowCalcutor(true)
                    self?.calcutor.setEditType(isEditAmount: false)
                    
                case 3:
                    self?.setShowCalcutor(false)
                    let vc = ChooseTypeViewController(addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                default:
                    break
                }
                
            } else {
                
                switch indexPath.row {
                case 0:
                    self?.setShowCalcutor(false)
                    let vc = ChooseTypeViewController(addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 1:
                    // 選擇帳戶
                    self?.setShowCalcutor(false)
                    let vc = ChooseAccountViewController(.normal, addDetailVM: self?.addDetailVM)
                    self?.push(vc: vc)
                    
                case 2:
                    // 填寫備註
                    break
                default:
                    break
                }
                
            }
            
            tableView.deselectRow(at: indexPath, animated: true)

        }).disposed(by: disposeBag)
    }
    
    private func setUpSpendCell(_ row: Int, _ cell: AddDetailCell) {
        cell.typeLabel.textColor = R.color.spendColor()
        
        if row == 0 {
            self.addDetailVM.typeName.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        }
        
        if row == 1 {
            self.addDetailVM.accountName.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        }
        
        if row == 2 {
            self.addDetailVM.memo.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        }
    }
    
    private func setUpIncomeCell(_ row: Int, _ cell: AddDetailCell) {
        cell.typeLabel.textColor = R.color.incomeColor()
        
        if row == 0 {
            self.addDetailVM.typeName.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        }
        
        if row == 1 {
            self.addDetailVM.accountName.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        }
        
        if row == 2 {
            self.addDetailVM.memo.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        }
    }
    
    private func setUpTransferCell(_ row: Int, _ cell: AddDetailCell) {
        cell.typeLabel.textColor = R.color.transferColor()
        
        switch row {
        case 0:
            self.addDetailVM.accountName.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        case 1:
            self.addDetailVM.toAccountName.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        case 2:
            cell.accessoryType = .none
            self.addDetailVM.transferFee.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        case 3:
            self.addDetailVM.typeName.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
        case 4:
            self.addDetailVM.memo.asDriver().drive(cell.typeLabel.rx.text).disposed(by: cell.disposeBag)
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
        
        let saveButton = UIButton()
        saveButton.setTitle(R.string.localizable.save(), for: .normal)
        saveButton.setTitleColor(R.color.transferColor(), for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 20)
        saveButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.addDetailVM.saveDetail()
            self?.pop()
        })
        .disposed(by: disposeBag)
        
        let delButton = UIButton()
        delButton.setTitle(R.string.localizable.delete(), for: .normal)
        delButton.setTitleColor(R.color.spendColor(), for: .normal)
        delButton.titleLabel?.font = .systemFont(ofSize: 20)
        delButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.addDetailVM.delDetail()
            self?.pop()
        })
        .disposed(by: disposeBag)
        
        stackView.addArrangedSubviews([delButton, saveButton])
        
        if addType == .add {
            delButton.isHidden = true
        }
    }
}
