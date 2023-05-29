//
//  DBTools.swift
//  MoneyManager
//
//  Created by 杜千煜 on 2023/3/30.
//

import Foundation

class DBTools {
    static func detailTypeToString(detailModel: DetailModel) -> String {
        guard let billingType = BillingType(rawValue: detailModel.billingType) else { return "" }
        var typeTitle = ""
        
        typeTitle += RealmManager.share.getDetailGroup(billType: billingType, groupId: detailModel.detailGroup).first?.name ?? ""
        typeTitle += " - \(RealmManager.share.getDetailType(typeId: detailModel.detailType).first?.name ?? "")"
        
        return typeTitle
    }
    
    static func detailTypeToString(billingType: BillingType, detailGroupId: String, detailTypeId: String) -> String {
        var typeTitle = ""
        
        typeTitle += RealmManager.share.getDetailGroup(billType: billingType, groupId: detailGroupId).first?.name ?? ""
        typeTitle += " - \(RealmManager.share.getDetailType(typeId: detailTypeId).first?.name ?? "")"
        
        return typeTitle
    }
}
