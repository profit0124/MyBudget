//
//  Transaction.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/1/25.
//

import Foundation
import SwiftData

@Model
class Transaction {
    @Attribute(.unique) var id: UUID
    var type: TransactionType
    var amount: Double
    var date: Date
    var category: Category
    var subCategory: SubCategory?
    var paymentMethod: PaymentMethodDetail
    var location: String?
    var memo: String?
    
    init(id: UUID, type: TransactionType, amount: Double, date: Date, category: Category, subCategory: SubCategory? = nil, paymentMethod: PaymentMethodDetail, location: String? = nil, memo: String? = nil) {
        self.id = id
        self.type = type
        self.amount = amount
        self.date = date
        self.category = category
        self.subCategory = subCategory
        self.paymentMethod = paymentMethod
        self.location = location
        self.memo = memo
    }
}

enum TransactionType: Int, Codable {
    case income
    case fixedExpance
    case varibleExpance
}
