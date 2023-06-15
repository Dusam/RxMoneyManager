//
//  ChooseTypeCell.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/15.
//

import UIKit

class ChooseTypeCell: UITableViewCell {

    var titleLabel = PaddingLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellView() {
        contentView.addSubview(titleLabel)
        
        titleLabel.font = .systemFont(ofSize: 18)
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }

}
