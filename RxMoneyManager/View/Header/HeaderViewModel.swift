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
    
    private let toNext = PublishSubject<Void>()
    private let toPervious = PublishSubject<Void>()
    private let toCurrent = PublishSubject<Void>()
    private let toSelected = PublishSubject<Void>()
    
    private let currentDate = BehaviorRelay<String>(value: UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
    
    private var headerType: HeaderType = .detail
    private var detailVM: DetailViewModel?
    
    init(headerType: HeaderType, detailVM: DetailViewModel? = nil) {
        super.init()

        self.headerType = headerType
        self.detailVM = detailVM
        
        input = .init(toNext: toNext,
                      toPervious: toPervious,
                      toCurrent: toCurrent,
                      toSelected: toSelected)
        output = .init(currentDate: currentDate.asDriver())
        subscribeInput()
        
    }
    
    private func toPerviousDate() {
        UserInfo.share.selectedDate = UserInfo.share.selectedDate.adding(.day, value: -1)
        currentDate.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    private func toNextDate() {
        UserInfo.share.selectedDate = UserInfo.share.selectedDate.adding(.day, value: 1)
        currentDate.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    private func toCurrentDate() {
        UserInfo.share.selectedDate = Date()
        currentDate.accept(UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd(EE)"))
        
        getDetail()
    }
    
    private func toSelectedDate() {
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
    private func subscribeInput() {
        input.toPervious
            .subscribe { [unowned self] _ in
                self.toPerviousDate()
            }
            .disposed(by: disposeBag)
        
        input.toNext
            .subscribe { [unowned self] _ in
                self.toNextDate()
            }
            .disposed(by: disposeBag)
        
        input.toCurrent
            .subscribe { [unowned self] _ in
                self.toCurrentDate()
            }
            .disposed(by: disposeBag)
        
        input.toSelected
            .subscribe { [unowned self] _ in
                self.toSelectedDate()
            }
            .disposed(by: disposeBag)
    }
}


extension HeaderViewModel {
    
    struct Input {
        let toNext: PublishSubject<Void>
        let toPervious: PublishSubject<Void>
        let toCurrent: PublishSubject<Void>
        let toSelected: PublishSubject<Void>
    }
    
    struct Output {
        let currentDate: Driver<String>
    }
}
