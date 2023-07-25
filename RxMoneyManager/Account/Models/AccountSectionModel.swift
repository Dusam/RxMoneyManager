//
//  AccountSectionModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/26.
//

import Foundation
import RxDataSources

struct AccountSectionModel {
    var sectionTitle: String = ""
    var items: [AccountModel] = []
}

extension AccountSectionModel: SectionModelType {
    
    init(original: AccountSectionModel, items: [AccountModel]) {
        self = original
        self.items = items
    }
}
