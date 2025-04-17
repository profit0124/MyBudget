//
//  BudgetRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 4/16/25.
//

import Foundation
import SwiftData

protocol BudgetRepository {
    func fetchBudget() async throws -> [Budget]
    func insertBudget(_ category: Budget) async throws
    func deleteBudget(_ category: Budget) async throws
    func updateBudget() async throws
}

final class BudgetRepositoryImplement: BudgetRepository {

    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchBudget() async throws -> [Budget] {
        let descriptor = FetchDescriptor<Budget>()
        return try await database.fetch(descriptor)
    }
    
    func insertBudget(_ category: Budget) async throws {
        try await database.insert(category)
    }
    
    func deleteBudget(_ category: Budget) async throws {
        try await database.delete(category)
    }
    
    func updateBudget() async throws {
        do {
            try await database.saveForUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
}
