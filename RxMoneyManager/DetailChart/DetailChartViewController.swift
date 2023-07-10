//
//  DetailChartViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/7.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxGesture
import RxDataSources
import DGCharts
import SamUtils

class DetailChartViewController: BaseViewController {
    
    private let detailChartVM: DetailChartViewModel = DetailChartViewModel()
    
    private var typeSegment: UISegmentedControl!
    private var headerView: UIStackView!
    private var pieChart: PieChartView!
    private var totalLabel: UILabel!
    private var detailChartTableView: UITableView!
    
    override func setUpView() {
        setBackButton(title: R.string.localizable.chart())
        
        setUpSegment()
        setUpHeaderView()
        setUpPieChartView()
        setUpTotalLabel()
        setUpDetailChartTableView()
    }

    override func bindUI() {
        bindTypeSegment()
        bindPieChartView()
        bindTotalLabel()
        bindDetailChartTableView()
    }
}

extension DetailChartViewController {
    private func setUpSegment() {
        typeSegment = UISegmentedControl()
        typeSegment.segmentTitles = DetailChartType.allCases.map{ $0.name }
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
    
    private func setUpHeaderView() {
        
        // 設定橫向 StackView
        func setUpStackView() {
            headerView = UIStackView()
            headerView.axis = .horizontal
            headerView.distribution = .fill
            headerView.backgroundColor = .lightGray
            
            view.addSubview(headerView)
          
            headerView.snp.makeConstraints { make in
                make.top.left.right.equalTo(safeAreaLayoutGuide)
                make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
            }
            
            let perviousButton = setUpPerviousButton()
            let centerView = setUpCenterView()
            let nextButton = setUpNextButton()
            
            headerView.addArrangedSubviews([perviousButton, centerView, nextButton])
            
            perviousButton.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.2)
            }
            
            nextButton.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.2)
            }
        }
        
        // 設定中間的 StackView(日期及共用標籤)
        func setUpCenterView() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            let dateLabel = setUpDateButton()
            stackView.addArrangedSubview(dateLabel)
          
            return stackView
        }
        
        // 設定日期按鈕
        func setUpDateButton() -> UIButton {
            let dateButton = UIButton()
            dateButton.titleLabel?.textAlignment = .center
            dateButton.titleLabel?.font = .systemFont(ofSize: 22)
            dateButton.setTitleColor(.black, for: .normal)
            dateButton.setTitleColor(.white, for: .highlighted)
            
            dateButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.detailChartVM.toCurrentDate()
            })
            .disposed(by: disposeBag)
            
            detailChartVM.currentDateString
                .drive(dateButton.rx.title())
                .disposed(by: disposeBag)
            
            return dateButton
        }
        
        // 設定上一天按鈕
        func setUpPerviousButton() -> UIButton {
            let perviousButton = UIButton()
            perviousButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
            perviousButton.tintColor = .white
            perviousButton.imageView?.contentMode = .scaleAspectFill
            
            perviousButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.detailChartVM.toPrevious()
            })
            .disposed(by: disposeBag)
            
            return perviousButton
        }
        
        // 設定下一天按鈕
        func setUpNextButton() -> UIButton {
            let nextButton = UIButton()
            nextButton.setImage(UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
            nextButton.tintColor = .white
            nextButton.imageView?.contentMode = .scaleAspectFill
            
            nextButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.detailChartVM.toNext()
            })
            .disposed(by: disposeBag)
            
            return nextButton
        }

        setUpStackView()
    }
    
    private func setUpPieChartView() {
        pieChart = PieChartView()
        pieChart.isUserInteractionEnabled = false
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.35
        pieChart.transparentCircleColor = .clear
        
        view.addSubview(pieChart)
        
        pieChart.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.4)
        }
    }
    
    private func setUpTotalLabel() {
        totalLabel = UILabel()
        totalLabel.textAlignment = .center
        totalLabel.font = .boldSystemFont(ofSize: 22)
        totalLabel.addBoard(.bottom, color: .lightGray, thickness: 0.5)
        
        view.addSubview(totalLabel)
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(pieChart.snp.bottom)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.9)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
    }
    
    private func setUpDetailChartTableView() {
        detailChartTableView = UITableView()
        detailChartTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        detailChartTableView.register(cellWithClass: DetailChartCell.self)
        
        view.addSubview(detailChartTableView)
        
        detailChartTableView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension DetailChartViewController {
    private func bindTypeSegment() {
        typeSegment.rx.selectedSegmentIndex
            .changed
            .subscribe(onNext: { [weak self] selectedIndex in
                self?.detailChartVM.setSegmentIndex(selectedIndex)
            })
            .disposed(by: disposeBag)
        
        detailChartVM.selectedSegment
            .drive(typeSegment.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
    
    private func bindPieChartView() {
        detailChartVM.pieChartData
            .drive(onNext: { [weak self] chartData in
                self?.pieChart.data = chartData
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTotalLabel() {
        detailChartVM.total
            .map { "總計: $\($0)" }
            .drive(totalLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindDetailChartTableView() {
        detailChartVM.detail
            .drive(detailChartTableView.rx.items(cellIdentifier: "DetailChartCell", cellType: DetailChartCell.self)) { row, data, cell in
                cell.totalLabel.text = "\(data.billingType.name) - $\(data.total)"
                cell.percentLabel.text = "\(data.percent)%"
                cell.progressView.progress = data.percent.float / 100
                cell.progressView.progressTintColor = data.billingType.forgroundColor
                cell.accessoryType = .disclosureIndicator
                
            }
            .disposed(by: disposeBag)
        
        detailChartTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.detailChartTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}


