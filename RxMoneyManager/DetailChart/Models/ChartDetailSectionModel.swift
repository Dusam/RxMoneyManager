//
//  ChartDetailSectionModel.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/7/10.
//

import Foundation
import RxDataSources

struct ChartDetailSectionModel {
    var sectionTitle: String = ""
    var items: [DetailModel] = []
}

extension ChartDetailSectionModel: SectionModelType {
    
    init(original: ChartDetailSectionModel, items: [DetailModel]) {
        self = original
        self.items = items
    }
}
