//
//  DetailChartCell.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/7.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SamUtils
import SwifterSwift
import SnapKit

class DetailChartCell: UITableViewCell {

    var disposeBag: DisposeBag!
    
    var totalLabel = UILabel()
    var percentLabel = UILabel()
    var progressView = UIProgressView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellView() {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 3
        vStackView.distribution = .fill
        
        contentView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-10)
            make.top.left.equalToSuperview().offset(10)
        }
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        
        totalLabel = UILabel()
        totalLabel.font = .systemFont(ofSize: 20)
        
        percentLabel = UILabel()
        percentLabel.font = .systemFont(ofSize: 20)
        percentLabel.textAlignment = .right
        
        progressView = UIProgressView()
        progressView.cornerRadius = 5
        
        hStackView.addArrangedSubviews([totalLabel, percentLabel])
        vStackView.addArrangedSubviews([hStackView, progressView])
        hStackView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
}
