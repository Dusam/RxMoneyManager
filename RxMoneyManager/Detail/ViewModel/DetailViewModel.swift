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
    static let shared = DetailViewModel()

    private var detailDatas: [DetailModel] = []
    var details = BehaviorRelay<[DetailModel]>(value: [])
    
    var totalAmount = BehaviorRelay<Int>(value: 0)
    
    init() {
        getDetail(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"))
    }
    
    func getDetail(_ date: String = UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd")) {
        detailDatas = RealmManager.share.readDetail(date)
        
        let addCell = DetailModel()
        addCell.billingType = 3
        detailDatas.append(addCell)
        
        countTotalAmount()
        
        details.accept(detailDatas)
    }
    
    func deleteDetail(_ detail: DetailModel) {
        detailDatas.removeAll(detail)
        details.accept(detailDatas)
        
        RealmManager.share.deleteDetail(detail.id)
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
}
