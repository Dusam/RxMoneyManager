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
    
    func getDetail(_ date: String) {
        detailDatas = RealmManager.share.readDetail(date)
        
        if date.toDate().isInToday {
            let testCell = DetailModel()
            testCell.detailGroup = "6474430120afe400bdb2a830"
            testCell.detailType = "6474430120afe400bdb2a832"
            testCell.accountId = try! ObjectId(string: "6474430120afe400bdb2a82f")
            testCell.accountName = "現金"
            testCell.billingType = 0
            testCell.amount = 185
            testCell.date = Date().string(withFormat: "yyyy-MM-dd")
            testCell.memo = "本丸"
            detailDatas.append(testCell)
            
            let testCell1 = DetailModel()
            testCell1.detailGroup = "6474430120afe400bdb2a88f"
            testCell1.detailType = "6474430120afe400bdb2a892"
            testCell1.accountId = try! ObjectId(string: "6474430120afe400bdb2a82f")
            testCell1.accountName = "現金"
            testCell1.billingType = 1
            testCell1.amount = 185
            testCell1.date = Date().string(withFormat: "yyyy-MM-dd")
            testCell1.memo = ""
            detailDatas.append(testCell1)
            
            let testCell2 = DetailModel()
            testCell2.detailGroup = "6474430120afe400bdb2a89d"
            testCell2.detailType = "6474430120afe400bdb2a89e"
            testCell2.accountId = try! ObjectId(string: "6474430120afe400bdb2a82f")
            testCell2.accountName = "現金"
            testCell2.toAccountId = try! ObjectId(string: "6474430120afe400bdb2a82f")
            testCell2.toAccountName = "現金"
            testCell2.billingType = 2
            testCell2.amount = 185
            testCell2.date = Date().string(withFormat: "yyyy-MM-dd")
            testCell2.memo = ""
            detailDatas.append(testCell2)
        }
        
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
