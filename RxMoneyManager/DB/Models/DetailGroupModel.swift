//
//  DetailGroupModel.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2023/2/9.
//

import Foundation
import RealmSwift

class DetailGroupModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var billType: Int = 0
    @Persisted var name: String = ""
}
