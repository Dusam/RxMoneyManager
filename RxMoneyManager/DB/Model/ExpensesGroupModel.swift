//
//  ExpensesGroup.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2022/10/24.
//

import Foundation
import RealmSwift

class ExpensesGroupModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var name: String = ""
}

