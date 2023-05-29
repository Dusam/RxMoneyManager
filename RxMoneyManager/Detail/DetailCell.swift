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
        
        selectionStyle = .none
        setUpCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellView() {
        
        func setUpVerticalStackView() {
            addSubview(verticalStackView)
            verticalStackView.axis = .vertical
            verticalStackView.distribution = .fill
            verticalStackView.spacing = 5
            
            verticalStackView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.left.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-5)
            }
        }
        
        func setUpFirstHorizontalStackView() {
            let stackView = UIStackView()
            verticalStackView.addArrangedSubview(stackView)
            stackView.axis = .horizontal
            stackView.distribution = .fill
            
            stackView.addArrangedSubviews([titleLabel, amountLabel])
            
            titleLabel.textAlignment = .left
            amountLabel.textAlignment = .right
            
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
            memoLabel.font = .systemFont(ofSize: 16)
            accountLabel.textAlignment = .right
            memoLabel.font = .systemFont(ofSize: 16)
            
            memoLabel.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.65)
            }
        }
        
        setUpVerticalStackView()
        setUpFirstHorizontalStackView()
        setUpSecondHorizontalStackView()
    }
    
}
