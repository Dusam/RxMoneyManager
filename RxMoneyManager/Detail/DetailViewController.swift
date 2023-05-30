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

class DetailViewController: BaseViewViewController {
    
    private var detailTableView: UITableView!
    private let headerView = HeaderView(headerType: .detail)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
                  
    deinit {
        #if DEBUG
        print("DetailViewController deinit")
        #endif
    }
    
    private func initView() {
        self.setBackButton(title: R.string.localizable.spend_details())
        
        self.setUpHeaderView()
        self.setUpTableView()
//        self.setUpSearchBar()
    }
    
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
            make.left.equalTo(safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.right.equalTo(safeAreaLayoutGuide).offset(-10)
        }
        
        bindTableView()
    }
    
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
                    cell.memoLabel.text = data.memo.replacing("\n", with: " ")
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
        
        // 設定 Delegate
        detailTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
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
                
        // 刪除項目
        detailTableView.rx.modelDeleted(DetailModel.self).subscribe(onNext: { detail in
            
        })
        .disposed(by: disposeBag)
    }
    
//    private func setUpSearchBar() {
//        let searchController = UISearchController()
//        let searchResults = searchController.searchBar.rx.text.orEmpty
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest { query -> Observable<[String]> in
//                if !query.isEmpty {
//                    return .just(["sss", "sss"])
//                }
//
//                return Observable.create { observer in
//                    observer.onNext(["testsss"])
//
//                    return Disposables.create()
//                }
//            }
//            .asDriver(onErrorJustReturn: ["sss"])
//
//        searchResults
//            .drive(detailTableView.rx.items(cellIdentifier: "DetailCell", cellType: DetailCell.self)) { row, data, cell in
//                cell.titleLabel.text = "餐飲食品 - 午餐"
//                cell.amountLabel.text = "TW$ 461"
//                cell.amountLabel.textColor = .red
//
//                cell.dateLabel.text = "2023-05-25"
//                cell.accountLabel.text = "國泰信用卡"
//            }
//            .disposed(by: disposeBag)
//
//        self.navigationItem.searchController = searchController
//    }


}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // 新增列不能滑動刪除
        if indexPath.row == DetailViewModel.shared.details.value.count - 1 {
            return .none
        }
        return .delete
    }
}

