//
//  BaseViewModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/13.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let disposeBag = DisposeBag()
    
    private let isShowCalcutorRelay = BehaviorRelay<Bool>(value: false)
    private(set) lazy var isShowCalcutor = isShowCalcutorRelay.asDriver()
    
    func setShowCalcutor(_ show: Bool) {
        isShowCalcutorRelay.accept(show)
    }
}
