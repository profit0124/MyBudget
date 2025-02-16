//
//  SubCategoryRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/16/25.
//

import Foundation
import SwiftData

protocol SubCategoryRepository {
    func fetchSubCategory() async throws -> [SubCategory]
    func insertSubCategory(_ subCategory: SubCategory) async throws
    func deleteSubCategory(_ subCategory: SubCategory) async throws
    func updateSubCategory() async throws
}

final class SubCategoryRepositoryImplement: SubCategoryRepository {

    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchSubCategory() async throws -> [SubCategory] {
        let descriptor = FetchDescriptor<SubCategory>()
        return try await database.fetch(descriptor)
    }
    
    func insertSubCategory(_ subCategory: SubCategory) async throws {
        try await database.insert(subCategory)
    }
    
    func deleteSubCategory(_ subCategory: SubCategory) async throws {
        try await database.delete(subCategory)
    }
    
    func updateSubCategory() async throws {
        do {
            try await database.saveForUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
}
