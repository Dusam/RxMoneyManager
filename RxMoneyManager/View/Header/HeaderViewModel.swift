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
    private let currentDateRelay = BehaviorRelay<String>(value: UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
    private(set) lazy var currentDate = currentDateRelay.asDriver()
//    var currentTime = BehaviorRelay<String>(value: UserInfo.share.selectedDate.string(withFormat: "HH:mm"))
    
    private var headerType: HeaderType = .detail
    private var detailVM: DetailViewModel?
    
    init(headerType: HeaderType, detailVM: DetailViewModel? = nil) {
        self.headerType = headerType
        self.detailVM = detailVM
    }
    
    func toPerviousDate() {
        UserInfo.share.selectedDate = UserInfo.share.selectedDate.adding(.day, value: -1)
        currentDateRelay.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    func toNextDate() {
        UserInfo.share.selectedDate = UserInfo.share.selectedDate.adding(.day, value: 1)
        currentDateRelay.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    func toCurrentDate() {
        UserInfo.share.selectedDate = Date()
        currentDateRelay.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    func toSelectedDate() {
        currentDateRelay.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        getDetail()
    }
    
    private func getDetail() {
        if headerType == .detail {
            detailVM?.getDetail(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"))
        }
    }
}
