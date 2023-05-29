//
//  ExpensesTypeModel.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/24.
//

import Foundation
import RealmSwift

class ExpensesTypeModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var expensesGroup: String = ""
    @Persisted var name: String = ""
}
