//
//  CategoryBudgetRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 4/16/25.
//

import Foundation
import SwiftData

protocol CategoryBudgetRepository {
    func fetchCategoryBudget() async throws -> [CategoryBudget]
    func insertCategoryBudget(_ category: CategoryBudget) async throws
    func deleteCategoryBudget(_ category: CategoryBudget) async throws
    func updateCategoryBudget() async throws
}

final class CategoryBudgetRepositoryImplement: CategoryBudgetRepository {

    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchCategoryBudget() async throws -> [CategoryBudget] {
        let descriptor = FetchDescriptor<CategoryBudget>()
        return try await database.fetch(descriptor)
    }
    
    func insertCategoryBudget(_ category: CategoryBudget) async throws {
        try await database.insert(category)
    }
    
    func deleteCategoryBudget(_ category: CategoryBudget) async throws {
        try await database.delete(category)
    }
    
    func updateCategoryBudget() async throws {
        do {
            try await database.saveForUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
}
