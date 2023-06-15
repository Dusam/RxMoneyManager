//
//  HeaderViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/26.
//

import Foundation
import RxCocoa
import RxSwift

enum HeaderType {
    case detail, addDetail
}

class HeaderViewModel {
    var currentDate = BehaviorRelay<String>(value: UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
    var currentTime = BehaviorRelay<String>(value: UserInfo.share.selectedDate.string(withFormat: "HH:mm"))
    
    private var headerType: HeaderType = .detail
    
    func setHeaderType(_ headerType: HeaderType) {
        self.headerType = headerType
    }
    
    func toPerviousDate() {
        UserInfo.share.selectedDate = UserInfo.share.selectedDate.adding(.day, value: -1)
        currentDate.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    func toNextDate() {
        UserInfo.share.selectedDate = UserInfo.share.selectedDate.adding(.day, value: 1)
        currentDate.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    func toCurrentDate() {
        UserInfo.share.selectedDate = Date()
        currentDate.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    private func getDetail() {
        if headerType == .detail {
            DetailViewModel.shared.getDetail(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"))
        }
    }
}