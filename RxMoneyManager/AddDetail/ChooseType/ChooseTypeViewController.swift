//
//  ChooseTypeViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/15.
//

import UIKit
import SamUtils
import RxSwift
import RxCocoa
import SnapKit
import RxGesture


class ChooseTypeViewController: BaseViewController {
    
    private var addDetailVM: AddDetailViewModel!
    
    private var boardView: UIView!
    private var groupTableView: UITableView!
    private var typeTableView: UITableView!
    private var tabView: UIView!
    private var addGroupButton: UIButton!
    private var addTypeButton: UIButton!

    init(addDetailVM: AddDetailViewModel!) {
        self.addDetailVM = addDetailVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("ChooseTypeViewController deinit")
        #endif
    }
    
    override func setUpView() {
        setBackButton(title: "選擇類型")
        
        setUpAddButtons()
        setUpBoardView()
        setUpGroupTableView()
        setUpTypeTableView()
    }
    
    override func bindUI() {
        bindGroupTableView()
        bindTypeTableView()
        bindAddButtons()
    }
    
}

// MARK: SetUpView
extension ChooseTypeViewController {
    private func setUpBoardView() {
        boardView = UIView()
        boardView.backgroundColor = .darkGray
        view.addSubview(boardView)
        
        boardView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(tabView.snp.top)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.002)
        }
    }
    
    private func setUpGroupTableView() {
        groupTableView = UITableView()
        view.addSubview(groupTableView)
        groupTableView.register(cellWithClass: ChooseTypeCell.self)
        groupTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        groupTableView.showsVerticalScrollIndicator = false
        groupTableView.snp.makeConstraints { make in
            make.top.left.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(tabView.snp.top)
            make.right.equalTo(boardView.snp.left)
        }
    }
    
    private func setUpTypeTableView() {
        typeTableView = UITableView()
        view.addSubview(typeTableView)
        typeTableView.register(cellWithClass: ChooseTypeCell.self)
        typeTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        typeTableView.showsVerticalScrollIndicator = false
        typeTableView.snp.makeConstraints { make in
            make.top.right.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(tabView.snp.top)
            make.left.equalTo(boardView.snp.right)
        }
    }
    
    private func setUpAddButtons() {
        tabView = UIView()
        tabView.backgroundColor = .white
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        addGroupButton = UIButton()
        addGroupButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        tabView.addSubview(addGroupButton)
        
        addGroupButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        addTypeButton = UIButton()
        addTypeButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        tabView.addSubview(addTypeButton)
        
        addTypeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.1)
        }
    }
}


// MARK: BindUI
extension ChooseTypeViewController {
    private func bindGroupTableView() {
        addDetailVM.output.detailGroupModels
            .drive(groupTableView.rx.items(cellIdentifier: "ChooseTypeCell", cellType: ChooseTypeCell.self)) { [weak self] row, data, cell in
                cell.titleLabel.text = data.name
                cell.titleLabel.paddingLeft = 15
                
                if self?.addDetailVM.getGroupId() == data.id.stringValue {
                    self?.groupTableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
                    self?.addDetailVM.setSelectGroup(data.id.stringValue)
                }
            }
            .disposed(by: disposeBag)
        
        groupTableView.rx.modelSelected(DetailGroupModel.self)
            .subscribe(onNext: { [weak self] data in
                self?.addDetailVM.setSelectGroup(data.id.stringValue)
            })
            .disposed(by: disposeBag)
        
        groupTableView.rx.modelDeleted(DetailGroupModel.self)
            .subscribe(onNext: { [weak self] data in
                self?.addDetailVM.deleteGroup(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTypeTableView() {
        addDetailVM.output.detailTypeModels
            .drive(typeTableView.rx.items(cellIdentifier: "ChooseTypeCell", cellType: ChooseTypeCell.self)) { [weak self] row, data, cell in
                cell.titleLabel.text = data.name
                cell.titleLabel.paddingLeft = 15
                
                if self?.addDetailVM.getTypeId() == data.id.stringValue {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            .disposed(by: disposeBag)
        
        typeTableView.rx.modelSelected(DetailTypeModel.self)
            .subscribe(onNext: { [weak self] data in
                self?.addDetailVM.setSelectType(data.id.stringValue)
                self?.pop()
            })
            .disposed(by: disposeBag)
        
        typeTableView.rx.modelDeleted(DetailTypeModel.self)
            .subscribe(onNext: { [weak self] data in
                self?.addDetailVM.deleteType(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAddButtons() {
        addGroupButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let alert = UIAlertController(title: "新增群組", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "群組名稱"
                }
                
                let submitAction = UIAlertAction(title: R.string.localizable.add(), style: .default) { [weak self] _ in
                    guard let groupName = alert.textFields?.first?.text else { return }
                    self?.addDetailVM.addGroup(groupName)
                }
                
                alert.addAction(submitAction)
                alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel))
                
                self?.present(alert, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        addTypeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let alert = UIAlertController(title: "新增類別", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "類別名稱"
                }
                
                let submitAction = UIAlertAction(title: R.string.localizable.add(), style: .default) { [weak self] _ in
                    guard let typeName = alert.textFields?.first?.text else { return }
                    self?.addDetailVM.addType(typeName)
                }
                
                alert.addAction(submitAction)
                alert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel))
                
                self?.present(alert, animated: true)
                
            })
            .disposed(by: disposeBag)
    }
}
