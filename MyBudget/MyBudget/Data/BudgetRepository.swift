//
//  BudgetRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 4/16/25.
//

import Foundation
import SwiftData

protocol BudgetRepository {
    func fetchCategory() async throws -> [Budget]
    func insertCategory(_ category: Budget) async throws
    func deleteCategory(_ category: Budget) async throws
    func updateCategory() async throws
}

final class BudgetRepositoryImplement: BudgetRepository {

    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchCategory() async throws -> [Budget] {
        let descriptor = FetchDescriptor<Budget>()
        return try await database.fetch(descriptor)
    }
    
    func insertCategory(_ category: Budget) async throws {
        try await database.insert(category)
    }
    
    func deleteCategory(_ category: Budget) async throws {
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
