//
//  CategorySetting.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/22/25.
//

import Foundation

import Foundation

// MARK: - SubCategory
/// Represents a sub-category, for example "급여" or "보너스".
/// 서브 카테고리(예: "급여", "보너스")를 나타냅니다.
struct SubCategoryEntity: Decodable, Identifiable, Hashable {
    // Unique identifier for SwiftUI diffing (SwiftUI 식별용 유일 ID)
    var id = UUID()
    // Name of the sub-category (서브 카테고리 이름)
    let name: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID().self
        self.name = try container.decode(String.self, forKey: .name)
    }
}

// MARK: - Category
/// Represents a category that contains multiple sub-categories, for example "근로소득".
/// 여러 서브 카테고리를 포함하는 카테고리(예: "근로소득")를 나타냅니다.
struct CategoryEntity: Decodable, Identifiable, Hashable {
    var id = UUID()
    // Name of the category (카테고리 이름)
    let name: String
    // Array of sub-categories under this category (해당 카테고리의 서브 카테고리 배열)
    var subCategory: [SubCategoryEntity]
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case subCategory
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID().self
        self.name = try container.decode(String.self, forKey: .name)
        self.subCategory = try container.decode([SubCategoryEntity].self, forKey: .subCategory)
    }
}

// MARK: - TransactionType
/// Represents a transaction type which groups categories, for example "수입".
/// 카테고리를 묶는 거래 타입(예: "수입")을 나타냅니다.
struct TransactionTypeEntity: Decodable, Identifiable, Hashable {
    var id = UUID()
    // The name of the transaction type (거래 타입 이름)
    let transactionType: String
    // Array of categories under this transaction type (해당 거래 타입에 속하는 카테고리 배열)
    var category: [CategoryEntity]
    
    enum CodingKeys: CodingKey {
        case id
        case transactionType
        case category
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID().self
        self.transactionType = try container.decode(String.self, forKey: .transactionType)
        self.category = try container.decode([CategoryEntity].self, forKey: .category)
    }
}
