//
//  AddDetailCell.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/14.
//

import UIKit

class AddDetailCell: UITableViewCell {
    
    var addTitleLabel = UILabel()
    var typeLabel = UILabel()

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
        
        horizontalStackView.addArrangedSubviews([addTitleLabel, typeLabel])
        
        addTitleLabel.textAlignment = .left
        addTitleLabel.font = .systemFont(ofSize: 18)
        
        typeLabel.textAlignment = .right
        typeLabel.font = .systemFont(ofSize: 18)
        
        addTitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
        }
    }
}
