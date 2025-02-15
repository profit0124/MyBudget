//
//  CategoryViewModel.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/15/25.
//

import Foundation
import Observation

@Observable
final class CategoryViewModel {
    
    var repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    var categories: [Category] = []
    var newCategoryName: String = ""
    
    enum Action {
        case fetch
        case insert
        case delete(Category)
        case update
    }
    
    func send(_ action: Action) async {
        do {
            switch action {
            case .fetch:
                try await fetch()
            case .insert:
                try await insert()
            case .delete(let category):
                try await delete(category)
            case .update:
                try await update()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetch() async throws {
        self.categories = try await repository.fetchCategory()
    }
    
    private func insert() async throws {
        let category = Category(name: newCategoryName)
        try await repository.insertCategory(category)
        newCategoryName = ""
        try await fetch()
    }
    
    private func delete(_ category: Category) async throws {
        try await repository.deleteCategory(category)
        try await fetch()
    }
    
    private func update() async throws {
        try await repository.updateCategory()
        try await fetch()
    }
    
}




