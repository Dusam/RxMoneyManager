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
import RxDataSources
import SamUtils
import SwifterSwift

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
        
    }
}
