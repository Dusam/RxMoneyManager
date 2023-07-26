//
//  DIContainer.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

import Foundation
import Swinject

class DIContainer {
    static let shared = DIContainer()
    private let container = Container()
    private init() {
        
    }

    func register() {
        registerViewModel()
    }
    
    func resolve<T>(_ type: T.Type, name: String? = nil) -> T? {
        return container.resolve(type, name: name)
    }
    
    private func registerViewModel() {
        container.register(DetailViewModelType.self) { _ in
            DetailViewModel()
        }.inObjectScope(.container)
        
        container.register(HeaderViewModelType.self) { r in
            HeaderViewModel(headerType: .detail, detailVM: r.resolve(DetailViewModelType.self)!)
        }.inObjectScope(.container)
        
        container.register(AddDetailViewModelType.self) { _ in
            AddDetailViewModel()
        }.inObjectScope(.container)
        
        container.register(AddAccountViewModelType.self) { _ in
            AddAccountViewModel()
        }.inObjectScope(.container)
        
        container.register(CalculatorViewModelType.self, name: "AddDetailViewModel") { r in
            r.resolve(AddDetailViewModelType.self)!
        }
        
        container.register(CalculatorViewModelType.self, name: "AddAccountViewModel") { r in
            r.resolve(AddAccountViewModelType.self)!
        }
        
        container.register(AccountViewModelType.self) { _ in
            AccountViewModel()
        }.inObjectScope(.container)
        
        container.register(DetailChartViewModelType.self) { _ in
            DetailChartViewModel()
        }.inObjectScope(.container)
    }
}
