//
//  CategoryBudget.swift
//  MyBudget
//
//  Created by Sooik Kim on 4/16/25.
//

import Foundation
import SwiftData

@Model
final class CategoryBudget: Sendable {
    @Attribute(.unique) var id: UUID = UUID()
    var categoryName: String
    var limit: Double

    init(categoryName: String, limit: Double) {
        self.categoryName = categoryName
        self.limit = limit
    }
}
