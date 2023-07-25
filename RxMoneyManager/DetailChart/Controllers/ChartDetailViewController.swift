//
//  ChartDetailViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources
import SnapKit
import SwifterSwift
import SamUtils

class ChartDetailViewController: BaseViewController {
    
    private var detailChartVM: DetailChartViewModel!
    private var chartDetailTableView: UITableView!
    private var chartDetailDataSource: RxTableViewSectionedReloadDataSource<ChartDetailSectionModel>!
    
    init(detailChartVM: DetailChartViewModel) {
        self.detailChartVM = detailChartVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        detailChartVM.setChart(with: detailChartVM.billingType)
    }

    override func setUpView() {
        setBackButton(title: detailChartVM.billingType.name)
        
        chartDetailTableView = UITableView()
        chartDetailTableView.register(cellWithClass: DetailCell.self)
        chartDetailTableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            chartDetailTableView.sectionHeaderTopPadding = 0
        }
        view.addSubview(chartDetailTableView)
        
        chartDetailTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func bindUI() {
        chartDetailDataSource = RxTableViewSectionedReloadDataSource<ChartDetailSectionModel>(configureCell: { (dataSource, tableView, indexPath, data) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
            let billingType = BillingType(rawValue: data.billingType)
            cell.titleLabel.text = DBTools.detailTypeToString(detailModel: data)
            cell.titleLabel.textColor = .black
            cell.amountLabel.text = "$\(data.amount.string)"
            cell.amountLabel.textColor = billingType?.forgroundColor
            cell.memoLabel.text = data.memo.replacingOccurrences(of: "\n", with: " ")
            cell.accountLabel.text = billingType == .transfer ? "\(data.accountName) -> \(data.toAccountName)" : data.accountName
            
            cell.memoLabel.isHidden = false
            cell.accountLabel.isHidden = false
            
            return cell
        })
        
        detailChartVM.output.chartSectionDatas
            .drive(chartDetailTableView.rx.items(dataSource: chartDetailDataSource))
            .disposed(by: disposeBag)
        
        chartDetailTableView.rx.modelSelected(DetailModel.self)
            .subscribe(onNext: { [weak self] detail in
                let addDetail = AddDetailViewController()
                addDetail.addType = .edit
                addDetail.detailModel = detail
                self?.push(vc: addDetail)
            })
            .disposed(by: disposeBag)
        
        chartDetailTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.chartDetailTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        chartDetailTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    deinit {
        #if DEBUG
        print("ChartDetailViewController deinit")
        #endif
    }

}


extension ChartDetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UserInfo.share.themeColor
        let titleLabel = PaddingLabel()
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.text = self.chartDetailDataSource?[section].sectionTitle
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
