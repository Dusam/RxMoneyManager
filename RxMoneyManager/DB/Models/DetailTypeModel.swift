//
//  DetailTypeModel.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2023/2/9.
//

import Foundation
import RealmSwift

class DetailTypeModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var groupId: String = ""
    @Persisted var name: String = ""
}
