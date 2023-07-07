//
//  ChooseAccountViewController.swift
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

class ChooseAccountViewController: BaseViewController {
    
    enum ChooseAccountType {
        case normal
        case transfer
    }
    
    private var addDetailVM: AddDetailViewModel!
    private var chooseAccountType: ChooseAccountType = .normal
    
    private var accountTableView: UITableView!
    private var addButton: UIButton!
    
    init(_ chooseAccountType: ChooseAccountType, addDetailVM: AddDetailViewModel!) {
        self.chooseAccountType = chooseAccountType
        self.addDetailVM = addDetailVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("ChooseAccountViewController deinit")
        #endif
    }
    
    override func setUpView() {
        self.setBackButton(title: R.string.localizable.account())
        setUpAccountTableView()
        setUpAddButton()
    }
    
    override func bindUI() {
        bindAccountTableView()
        bindAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addDetailVM.getAccounts()
    }
    
    override func viewWillLayoutSubviews() {
        addButton.cornerRadius = addButton.width / 2
    }

}

// MARK: SetUpView
extension ChooseAccountViewController {
    private func setUpAccountTableView() {
        accountTableView = UITableView()
        accountTableView.register(cellWithClass: ChooseAccountCell.self)
        accountTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(accountTableView)
        
        accountTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setUpAddButton() {
        addButton = UIButton()
        addButton.tintColor = .white
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        addButton.backgroundColor = .blue
        
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(addButton.snp.height)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.15)
        }
    }
}


// MARK: BindUI
extension ChooseAccountViewController {
    private func bindAccountTableView() {
        addDetailVM.accountModels
            .drive(accountTableView.rx.items(cellIdentifier: "ChooseAccountCell", cellType: ChooseAccountCell.self)) { row, data, cell in
                cell.titleLabel.text = data.name
                cell.titleLabel.paddingLeft = 10
                cell.accessoryType = .none
                
                if self.chooseAccountType == .normal {
                    if data.id.stringValue == self.addDetailVM.getAccountId() {
                        cell.accessoryType = .checkmark
                    }
                } else {
                    if data.id.stringValue == self.addDetailVM.getToAccountId() {
                        cell.accessoryType = .checkmark
                    }
                }
            }
            .disposed(by: disposeBag)
        
        accountTableView.rx.modelSelected(AccountModel.self).subscribe(onNext: { [weak self] data in
            if self?.chooseAccountType == .normal {
                self?.addDetailVM.setAccountId(data.id.stringValue)
            } else {
                self?.addDetailVM.setToAccountId(data.id.stringValue)
            }
            
            self?.pop()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindAddButton() {
        addButton.rx.tap.subscribe(onNext: {
            let vc = AddAccountViewController()
            self.push(vc: vc)
        })
        .disposed(by: disposeBag)
    }
}
