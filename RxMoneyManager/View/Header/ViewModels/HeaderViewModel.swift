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

class HeaderViewModel: BaseViewModel, ViewModelType {
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let currentDate = BehaviorRelay<String>(value: UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
    
    private var headerType: HeaderType = .detail
    private var detailVM: DetailViewModel?
    
    init(headerType: HeaderType, detailVM: DetailViewModel? = nil) {
        super.init()

        self.headerType = headerType
        self.detailVM = detailVM
        
        input = .init()
        output = .init(currentDate: currentDate.asDriver())
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
    
    func toSelectedDate() {
        currentDate.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        getDetail()
    }
    
    private func getDetail() {
        if headerType == .detail {
            detailVM?.getDetail(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"))
        }
    }
}

extension HeaderViewModel {
    struct Input {
        
    }
    
    struct Output {
        let currentDate: Driver<String>
    }
}
