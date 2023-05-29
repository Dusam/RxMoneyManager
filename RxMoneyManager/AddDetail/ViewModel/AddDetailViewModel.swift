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
    
    func setEditData(_ data: DetailModel) {
        detail.accept(data)
    }
    
    func saveDetail() {
        RealmManager.share.saveData(detail.value)
    }
}
