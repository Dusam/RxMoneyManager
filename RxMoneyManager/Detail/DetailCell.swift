//
//  DetailCell.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/25.
//

import UIKit

class DetailCell: UITableViewCell {
    
    private var verticalStackView = UIStackView()
    
    var titleLabel = UILabel()
    var amountLabel = UILabel()
    var memoLabel = UILabel()
    var accountLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellView() {
        
        func setUpVerticalStackView() {
            contentView.addSubview(verticalStackView)
            verticalStackView.axis = .vertical
            verticalStackView.distribution = .fill
            verticalStackView.spacing = 5
            
            verticalStackView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            }
        }
        
        func setUpFirstHorizontalStackView() {
            let stackView = UIStackView()
            verticalStackView.addArrangedSubview(stackView)
            stackView.axis = .horizontal
            stackView.distribution = .fill
            
            stackView.addArrangedSubviews([titleLabel, amountLabel])
            
            titleLabel.textAlignment = .left
            titleLabel.font = .systemFont(ofSize: 18)
            amountLabel.textAlignment = .right
            amountLabel.font = .systemFont(ofSize: 18)
            
            titleLabel.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.65)
            }
        }
        
        func setUpSecondHorizontalStackView() {
            let stackView = UIStackView()
            verticalStackView.addArrangedSubview(stackView)
            stackView.axis = .horizontal
            stackView.distribution = .fill
            
            stackView.addArrangedSubviews([memoLabel, accountLabel])
            
            memoLabel.textAlignment = .left
            memoLabel.textColor = .lightGray
            memoLabel.font = .systemFont(ofSize: 18)
            accountLabel.textAlignment = .right
            accountLabel.adjustsFontSizeToFitWidth = true
            accountLabel.font = .systemFont(ofSize: 18)
            
            memoLabel.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.5)
            }
        }
        
        setUpVerticalStackView()
        setUpFirstHorizontalStackView()
        setUpSecondHorizontalStackView()
    }
    
}
