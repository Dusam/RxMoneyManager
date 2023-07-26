//
//  Inject.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/25.
//

@propertyWrapper
public struct Inject<T> {
    public private(set) var wrappedValue: T

    public init() {
        self.init(name: nil)
    }

    public init(name: String? = nil) {
        guard let value = DIContainer.shared.resolve(T.self, name: name) else {
            fatalError("Could not resolve non-optional \(T.self)")
        }
        
        wrappedValue = value
    }
}
