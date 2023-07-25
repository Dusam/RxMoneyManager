//
//  AccountCell.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/26.
//

import UIKit
import RxSwift
import RxCocoa

class AccountCell: UITableViewCell {

    var disposeBag: DisposeBag!
    var accountNameLabel = UILabel()
    var amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellView() {
        let horizontalStackView = UIStackView()
        contentView.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 5
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        horizontalStackView.addArrangedSubviews([accountNameLabel, amountLabel])
        
        accountNameLabel.textAlignment = .left
        accountNameLabel.font = .systemFont(ofSize: 18)
        
        amountLabel.textAlignment = .right
        amountLabel.font = .systemFont(ofSize: 18)
        
        accountNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
}
