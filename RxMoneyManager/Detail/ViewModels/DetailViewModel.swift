//
//  DetailViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/26.
//

import Foundation
import RxSwift
import RxCocoa
import SamUtils
import RealmSwift

class DetailViewModel: DetailViewModelType {
    
    private(set) var input: Input!
    private(set) var output: Output!

    private var detailDatas: [DetailModel] = []
    
    private let details = BehaviorRelay<[DetailModel]>(value: [])
    private let totalAmount = BehaviorRelay<Int>(value: 0)
    private let themeColor = BehaviorRelay<UIColor>(value: UserInfo.share.themeColor)
    
    init() {
        
        input = .init()
        output = .init(totalAmount: totalAmount.map{ "$TW \($0)" }.asDriver(onErrorJustReturn: ""),
                       details: details.asDriver(),
                       themeColor: themeColor.asDriver())
    }
    
    func getDetail(_ date: String = UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd")) {
        detailDatas = RealmManager.share.readDetail(date)
        
        let addCell = DetailModel()
        addCell.billingType = 3
        detailDatas.append(addCell)
        
        countTotalAmount()
        
        details.accept(detailDatas)
    }
    
    private func countTotalAmount() {
        var total = 0
        detailDatas.forEach { detail in
            if detail.billingType == 0 {
                total -= detail.amount
            } else if detail.billingType == 1 {
                total += detail.amount
            }
        }
        
        totalAmount.accept(total)
    }
    
    func setThemeColor(_ color: UIColor) {
        themeColor.accept(color)
    }
}

extension DetailViewModel {
    struct Input {
        
    }
    
    struct Output {
        let totalAmount: Driver<String>
        let details: Driver<[DetailModel]>
        let themeColor: Driver<UIColor>
    }
}
