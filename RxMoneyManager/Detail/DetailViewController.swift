//
//  ViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/25.
//

import UIKit
import SamUtils
import RxSwift
import RxCocoa
import SnapKit

class DetailViewController: BaseViewController {
    
    private var detailTableView: UITableView!
    private var tabView: UIView!
    private let headerView = HeaderView(headerType: .detail)
    
    private var accountButton: UIButton!
    private var settingButton: UIButton!
   
    deinit {
        #if DEBUG
        print("DetailViewController deinit")
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 與新增時選擇的日期同步
        headerView.toSelectedDate()
    }
    
    override func setUpView() {
        setBackButton(title: R.string.localizable.spend_details())
        
        setUpHeaderView()
        setUpTableView()
        setUpTabView()
    }
    
    override func bindUI() {
        bindThemeColor()
        bindTableView()
        bindButtons()
    }
}


// MARK: SetUpView
extension DetailViewController {
    // 設定標題列
    private func setUpHeaderView() {
        self.view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
    }
    
    // 設定 TableView
    private func setUpTableView() {
        detailTableView = UITableView()
        self.view.addSubview(detailTableView)
        detailTableView.register(cellWithClass: DetailCell.self)
        detailTableView.separatorStyle = .none
        
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setUpTabView() {
        tabView = UIView()
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        tabView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        accountButton = UIButton()
        accountButton.setTitle(R.string.localizable.account(), for: .normal)
        accountButton.setTitleColor(.systemGray, for: .highlighted)
        accountButton.tintColor = .white
        accountButton.setImage(UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        accountButton.centerTextAndImage(imageAboveText: true, spacing: 5)
        
        settingButton = UIButton()
        settingButton.setTitle(R.string.localizable.setting(), for: .normal)
        settingButton.setTitleColor(.systemGray, for: .highlighted)
        settingButton.tintColor = .white
        settingButton.setImage(UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        settingButton.centerTextAndImage(imageAboveText: true, spacing: 5)
        
        stackView.addArrangedSubviews([accountButton, settingButton])
    }
}


// MARK: BindUI
extension DetailViewController {
    // 數據綁定 TableView
    private func bindTableView() {
        DetailViewModel.shared.details
            .bind(to: detailTableView.rx.items(cellIdentifier: "DetailCell", cellType: DetailCell.self)) { row, data, cell in
                if data.billingType < 3 {
                    let billingType = BillingType(rawValue: data.billingType)
                    cell.titleLabel.text = DBTools.detailTypeToString(detailModel: data)
                    cell.titleLabel.textColor = .black
                    cell.amountLabel.text = "$\(data.amount.string)"
                    cell.amountLabel.textColor = billingType?.forgroundColor
                    cell.memoLabel.text = data.memo.replacingOccurrences(of: "\n", with: " ")
                    cell.accountLabel.text = billingType == .transfer ? "\(data.accountName) -> \(data.toAccountName)" : data.accountName
                    
                    cell.memoLabel.isHidden = false
                    cell.accountLabel.isHidden = false
                } else {
                    cell.titleLabel.text = R.string.localizable.addNew()
                    cell.titleLabel.textColor = .lightGray
                    cell.amountLabel.text = ""
                    
                    cell.memoLabel.isHidden = true
                    cell.accountLabel.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        // 選取項目
        detailTableView.rx.modelSelected(DetailModel.self).subscribe(onNext: { detail in
            let addDetail = AddDetailViewController()

            if detail.billingType < 3 {
                addDetail.addType = .edit
                addDetail.detailModel = detail
            } else {
                addDetail.addType = .add
            }
            
            self.push(vc: addDetail)
        })
        .disposed(by: disposeBag)
        
        detailTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.detailTableView.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindThemeColor() {
        DetailViewModel.shared.themeColor
            .subscribe(onNext: { [weak self] color in
                UserInfo.share.themeColor = color
                self?.setNavigationColor(navigationColor: color)
                self?.setNeedsStatusBarAppearanceUpdate()
            })
            .disposed(by: disposeBag)
        
        DetailViewModel.shared.themeColor
            .bind(to: tabView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }

    private func bindButtons() {
        accountButton.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .subscribe(onNext: {
                self.push(vc: SettingViewController())
            })
            .disposed(by: disposeBag)
    }
}
