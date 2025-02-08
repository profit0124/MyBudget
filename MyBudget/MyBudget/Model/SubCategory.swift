//
//  SubCategory.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/3/25.
//

import Foundation
import SwiftData

@Model
class SubCategory {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var parentCategory: Category

    init(name: String, parentCategory: Category) {
        self.name = name
        self.parentCategory = parentCategory
    }
}
