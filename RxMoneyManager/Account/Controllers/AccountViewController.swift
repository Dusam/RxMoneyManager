//
//  AccountViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/26.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwifterSwift
import SamUtils
import SnapKit

class AccountViewController: BaseViewController {

    @Inject private var accountVM: AccountViewModelType
    
    private var addAccountButton: UIBarButtonItem!
    
    private var accountHeaderView: UIStackView!
    private var totalAssetsLabel: PaddingLabel!
    private var totalLiabilityLabel: PaddingLabel!
    private var balanceLabel: PaddingLabel!
    
    private var accountTableView: UITableView!
    private var accountDataSource: RxTableViewSectionedReloadDataSource<AccountSectionModel>!
    
    override func setUpView() {
        setBackButton(title: R.string.localizable.account())
        setUpAddAccountButton()
        setUpAccountView()
        setUpTableView()
    }
    
    override func bindUI() {
        bindAddAccountButton()
        bindLabel()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountVM.getAccounts()
    }
    
    deinit {
        #if DEBUG
        print("AccountViewController deinit")
        #endif
    }
}

// MARK: SetUpView
extension AccountViewController {
    private func setUpAccountView() {
        accountHeaderView = UIStackView()
        accountHeaderView.axis = .vertical
        accountHeaderView.distribution = .fillEqually
        accountHeaderView.spacing = 10
        
        view.addSubview(accountHeaderView)
        
        accountHeaderView.snp.makeConstraints { make in
            make.top.left.equalTo(safeAreaLayoutGuide).offset(10)
            make.right.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.2)
        }
        
        accountHeaderView.addArrangedSubviews([setUpTotalAssetsView(), setUpTotalLiabilityView(), setUpBalanceView()])
        
        func setUpTotalAssetsView() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            let totalAssetsTitleLabel = UILabel()
            totalAssetsTitleLabel.font = .systemFont(ofSize: 20)
            totalAssetsTitleLabel.text = R.string.localizable.totalAssets()
            
            totalAssetsLabel = PaddingLabel()
            totalAssetsLabel.font = .systemFont(ofSize: 20)
            totalAssetsLabel.textAlignment = .right
            
            stackView.addArrangedSubviews([totalAssetsTitleLabel, totalAssetsLabel])
            
            return stackView
        }
        
        func setUpTotalLiabilityView() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            let totalLiabilityTitleLabel = UILabel()
            totalLiabilityTitleLabel.font = .systemFont(ofSize: 20)
            totalLiabilityTitleLabel.text = R.string.localizable.totalLiability()
            
            totalLiabilityLabel = PaddingLabel()
            totalLiabilityLabel.font = .systemFont(ofSize: 20)
            totalLiabilityLabel.textAlignment = .right
            
            stackView.addArrangedSubviews([totalLiabilityTitleLabel, totalLiabilityLabel])
            
            return stackView
        }
        
        func setUpBalanceView() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            let balanceTitleLabel = UILabel()
            balanceTitleLabel.font = .systemFont(ofSize: 20)
            balanceTitleLabel.text = R.string.localizable.theBalance()
            
            balanceLabel = PaddingLabel()
            balanceLabel.font = .systemFont(ofSize: 20)
            balanceLabel.textAlignment = .right
            
            stackView.addArrangedSubviews([balanceTitleLabel, balanceLabel])
            
            return stackView
        }
        
    }
    
    private func setUpTableView() {
        accountTableView = UITableView()
        accountTableView.register(cellWithClass: AccountCell.self)
        accountTableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            accountTableView.sectionHeaderTopPadding = 0
        }
        view.addSubview(accountTableView)
        
        accountTableView.snp.makeConstraints { make in
            make.top.equalTo(accountHeaderView.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setUpAddAccountButton() {
        addAccountButton = UIBarButtonItem(title: R.string.localizable.add(), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addAccountButton
    }
}
    

// MARK: BindUI
extension AccountViewController {
    private func bindTableView() {
        accountDataSource = RxTableViewSectionedReloadDataSource<AccountSectionModel>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
            cell.accountNameLabel.font = .systemFont(ofSize: 20)
            cell.accountNameLabel.text = item.name
            cell.amountLabel.font = .systemFont(ofSize: 20)
            cell.amountLabel.text = "$\(item.money.string)"
            cell.amountLabel.textColor = item.money >= 0 ? R.color.incomeColor() : R.color.spendColor()
            
            return cell
        })
        
        accountVM.output.accountModels
            .drive(accountTableView.rx.items(dataSource: accountDataSource))
            .disposed(by: disposeBag)
        
        accountTableView.rx.modelSelected(AccountModel.self)
            .subscribe(onNext: { account in
                // 進入該帳戶細項頁面
            })
            .disposed(by: disposeBag)
        
        accountTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.accountTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        accountTableView.rx.modelDeleted(AccountModel.self)
            .subscribe(onNext: { [weak self] account in
                self?.accountVM.deleteAccount(account)
            })
            .disposed(by: disposeBag)
        
        accountTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindLabel() {
        accountVM.output.totalAssets
            .drive(totalAssetsLabel.rx.text)
            .disposed(by: disposeBag)
        
        accountVM.output.totalAssetsColor
            .drive(totalAssetsLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        accountVM.output.totalLiability
            .drive(totalLiabilityLabel.rx.text)
            .disposed(by: disposeBag)
        
        accountVM.output.totalLiabilityColor
            .drive(totalLiabilityLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        accountVM.output.balance
            .drive(balanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        accountVM.output.balanceColor
            .drive(balanceLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
    
    private func bindAddAccountButton() {
        addAccountButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.push(vc: AddAccountViewController())
            })
            .disposed(by: disposeBag)
    }
}
    

extension AccountViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UserInfo.share.themeColor
        let titleLabel = PaddingLabel()
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.text = self.accountDataSource?[section].sectionTitle
        titleLabel.textColor = UserInfo.share.themeColor.isLight ? .black : .white
        titleLabel.paddingLeft = 10
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
