//
//  CategoryRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/15/25.
//

import Foundation
import SwiftData

protocol CategoryRepository {
    func fetchCategory() async throws -> [Category]
    func insertCategory(_ category: Category) async throws
    func deleteCategory(_ category: Category) async throws
    func updateCategory() async throws
    func seedRecomendedCategory() async throws
}

final class CategoryRepositoryImplement: CategoryRepository {

    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchCategory() async throws -> [Category] {
        let descriptor = FetchDescriptor<Category>()
        return try await database.fetch(descriptor)
    }
    
    func insertCategory(_ category: Category) async throws {
        try await database.insert(category)
    }
    
    func deleteCategory(_ category: Category) async throws {
        try await database.delete(category)
    }
    
    func updateCategory() async throws {
        do {
            try await database.saveForUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func seedRecomendedCategory() async throws {
        guard let url = Bundle.main.url(forResource: "RecomendedCategory", withExtension: "json") else {
            throw NSError(domain: "Seeder", code: 404, userInfo: [NSLocalizedDescriptionKey: "JSON 파일을 찾을 수 없습니다."])
        }

        let data = try Data(contentsOf: url)
        let parsed = try JSONDecoder().decode([TransactionTypeEntity].self, from: data)

        for typeEntity in parsed {
            guard let transactionType = TransactionType.fromKoreanName(typeEntity.transactionType) else { continue }

            for categoryEntity in typeEntity.category {
                let category = Category(name: categoryEntity.name, transactionType: transactionType)

                let subCategories = categoryEntity.subCategory.map {
                    SubCategory(name: $0.name, parentCategory: category)
                }
                category.subCategories.append(contentsOf: subCategories)
                try await database.insert(category)
            }
        }
    }
}
