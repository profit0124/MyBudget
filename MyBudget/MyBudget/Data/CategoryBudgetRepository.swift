//
//  CategoryBudgetRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 4/16/25.
//

import Foundation
import SwiftData

protocol CategoryBudgetRepository {
    func fetchCategory() async throws -> [CategoryBudget]
    func insertCategory(_ category: CategoryBudget) async throws
    func deleteCategory(_ category: CategoryBudget) async throws
    func updateCategory() async throws
}

final class CategoryBudgetRepositoryImplement: CategoryBudgetRepository {

    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchCategory() async throws -> [CategoryBudget] {
        let descriptor = FetchDescriptor<CategoryBudget>()
        return try await database.fetch(descriptor)
    }
    
    func insertCategory(_ category: CategoryBudget) async throws {
        try await database.insert(category)
    }
    
    func deleteCategory(_ category: CategoryBudget) async throws {
        try await database.delete(category)
    }
    
    func updateCategory() async throws {
        do {
            try await database.saveForUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
}
