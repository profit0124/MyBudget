//
//  Budget.swift
//  MyBudget
//
//  Created by Sooik Kim on 4/16/25.
//

import Foundation
import SwiftData

@Model
final class Budget: Sendable {
    @Attribute(.unique) var id: UUID = UUID()
    var month: Date
    var totalLimit: Double?
    var isCustom: Bool = false
    var categoryBudgets: [CategoryBudget]

    init(month: Date,
         totalLimit: Double? = nil,
         isCustom: Bool = false,
         categoryBudgets: [CategoryBudget] = []) {
        self.month = month
        self.totalLimit = totalLimit
        self.isCustom = isCustom
        self.categoryBudgets = categoryBudgets
    }
}
