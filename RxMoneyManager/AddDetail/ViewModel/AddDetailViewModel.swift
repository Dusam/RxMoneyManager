//
//  AddDetailViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/26.
//

import Foundation
import RxCocoa
import RxSwift

class AddDetailViewModel {
    private var detail = BehaviorRelay<DetailModel>(value: DetailModel())
    
    let amount = BehaviorRelay<String>(value: "0")
    let isShowCalcutor = BehaviorRelay<Bool>(value: false)
    let selectedSegmentRelay = BehaviorRelay<Int>(value: 0)
    
    func setShowCalcutor(_ show: Bool) {
        isShowCalcutor.accept(show)
    }
    
    func setEditData(_ data: DetailModel) {
        detail.accept(data)
    }
    
    func saveDetail() {
        RealmManager.share.saveData(detail.value)
    }
}
