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
}
