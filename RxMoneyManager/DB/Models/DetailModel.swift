//
//  DetailModel.swift
//  MoneyManager
//
//  Created by Qian-Yu Du on 2022/5/26.
//

import Foundation
import RealmSwift

class DetailModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var billingType: Int = 0
    @Persisted var accountId: ObjectId
    @Persisted var accountName: String
    @Persisted var toAccountId: ObjectId
    @Persisted var toAccountName: String
    @Persisted var detailGroup: String = "0"
    @Persisted var detailType: String = "0"
    @Persisted var amount: Int = 0
    @Persisted var memo: String = ""
    @Persisted var date: String = ""
    @Persisted var modifyDateTime: String = ""
}
