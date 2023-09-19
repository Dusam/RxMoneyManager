//
//  MemoModel.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/11/17.
//

import Foundation
import RealmSwift

class MemoModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var billingType: Int = 0
    @Persisted var detailGroup: String = "0"
    @Persisted var memo: String = ""
    @Persisted var count: Int = 0
}
