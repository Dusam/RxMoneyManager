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

class DetailViewModel {
//    static let shared = DetailViewModel()

    private var detailDatas: [DetailModel] = []
    
    private let detailsRelay = BehaviorRelay<[DetailModel]>(value: [])
    private(set) lazy var details = detailsRelay.asDriver(onErrorJustReturn: [])

    private let totalAmountRelay = BehaviorRelay<Int>(value: 0)
    private(set) lazy var totalAmount = totalAmountRelay.asDriver(onErrorJustReturn: 0)
    
    private let themeColorRelay = BehaviorRelay<UIColor>(value: UserInfo.share.themeColor)
    private(set) lazy var themeColor = themeColorRelay.asDriver()
    
    init() {
        getDetail(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"))
    }
    
    func getDetail(_ date: String = UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd")) {
        detailDatas = RealmManager.share.readDetail(date)
        
        let addCell = DetailModel()
        addCell.billingType = 3
        detailDatas.append(addCell)
        
        countTotalAmount()
        
        detailsRelay.accept(detailDatas)
    }
    
    func deleteDetail(_ detail: DetailModel) {
        detailDatas.removeAll(detail)
        detailsRelay.accept(detailDatas)
        
        RealmManager.share.delete(detail)
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
        
        totalAmountRelay.accept(total)
    }
    
    func setThemeColor(_ color: UIColor) {
        themeColorRelay.accept(color)
    }
}
