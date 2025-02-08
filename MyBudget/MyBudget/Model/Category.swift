//
//  Category.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/3/25.
//

import Foundation
import SwiftData

@Model
class Category {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var subCategories: [SubCategory]?

    init(name: String, subCategories: [SubCategory]?) {
        self.name = name
        self.subCategories = subCategories
    }
}
