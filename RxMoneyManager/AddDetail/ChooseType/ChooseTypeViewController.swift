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
        
        setUpBoardView()
        setUpGroupTableView()
        setUpTypeTableView()
    }
    
    override func bindUI() {
        bindGroupTableView()
        bindTypeTableView()
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
            make.top.bottom.equalTo(safeAreaLayoutGuide)
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
            make.top.left.bottom.equalTo(safeAreaLayoutGuide)
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
            make.top.right.bottom.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(boardView.snp.right)
        }
    }
}


// MARK: BindUI
extension ChooseTypeViewController {
    private func bindGroupTableView() {
        addDetailVM.detailGroupModels
            .bind(to: groupTableView.rx.items(cellIdentifier: "ChooseTypeCell", cellType: ChooseTypeCell.self)) { [weak self] row, data, cell in
                cell.titleLabel.text = data.name
                cell.titleLabel.paddingLeft = 15
                
                if data.id.stringValue == UserInfo.share.expensesGroupId
                    || data.id.stringValue == UserInfo.share.incomeGroupId
                    || data.id.stringValue == UserInfo.share.transferGroupId {
                    self?.groupTableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
                    self?.addDetailVM.setSelectGroup(data.id.stringValue)
                }
            }
            .disposed(by: disposeBag)
        
        groupTableView.rx.modelSelected(DetailGroupModel.self).subscribe(onNext: { [weak self] data in
            self?.addDetailVM.setSelectGroup(data.id.stringValue)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindTypeTableView() {
        addDetailVM.detailTypeModels
            .bind(to: typeTableView.rx.items(cellIdentifier: "ChooseTypeCell", cellType: ChooseTypeCell.self)) { row, data, cell in
                cell.titleLabel.text = data.name
                cell.titleLabel.paddingLeft = 15
            }
            .disposed(by: disposeBag)
        
        typeTableView.rx.modelSelected(DetailTypeModel.self)
            .subscribe(onNext: { [weak self] data in
                self?.addDetailVM.setSelectType(data.id.stringValue)
                self?.pop()
            })
            .disposed(by: disposeBag)
    }
}
