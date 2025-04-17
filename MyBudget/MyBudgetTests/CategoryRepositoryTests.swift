//
//  CategoryRepositoryTests.swift
//  MyBudgetTests
//
//  Created by Sooik Kim on 2/15/25.
//

import Testing
@testable import MyBudget

struct CategoryRepositoryTests {
    
    let repository: CategoryRepository
    
    init() {
        let database = Database(isStoredInMemoryOnly: true)
        self.repository = CategoryRepositoryImplement(database: database)
    }

    @Test func testFetch() async {
        
        let categories = try? await repository.fetchCategory()
        #expect(categories != nil)
        #expect(categories?.count == 0)
    }
    
    @Test func testInsert() async throws {
        let category1 = Category(name: "Category1", transactionType: .income)
        let category2 = Category(name: "Category2", transactionType: .income)
        
        try await repository.insertCategory(category1)
        var categories = try await repository.fetchCategory()
        #expect(categories.count == 1)
        try await repository.insertCategory(category2)
        categories = try await repository.fetchCategory()
        #expect(categories.count == 2)
    }
    
    @Test func testDelete() async throws {
        let category1 = Category(name: "Category3", transactionType: .income)
        try await repository.insertCategory(category1)
        var categories = try await repository.fetchCategory()
        #expect(categories.count == 1)
        try await repository.deleteCategory(category1)
        categories = try await repository.fetchCategory()
        #expect(categories.count == 0)
    }
    
    @Test func testUpdate() async throws {
        let categoryName = "Category4"
        let category1 = Category(name: categoryName, transactionType: .income)
        try await repository.insertCategory(category1)
        let category = try await repository.fetchCategory().first!
        #expect(category.name == categoryName)
        category.name = "NewName"
        try await repository.updateCategory()
        let categories = try await repository.fetchCategory()
        #expect(categories.count == 1)
        #expect(categories.first!.id == category1.id)
        #expect(categories.first!.name == category.name)
    }
    
    @Test func testSeedRecomendedCategory() async throws {
        // 1. 사전 상태 확인 - 비어있어야 함
        var categories = try await repository.fetchCategory()
        #expect(categories.isEmpty)

        // 2. 시드 함수 실행
        try await repository.seedRecomendedCategory()

        // 3. 시드 결과 확인
        categories = try await repository.fetchCategory()
        #expect(!categories.isEmpty)

        // 4. 하위 카테고리 포함 확인
        let firstCategory = categories.first!
        #expect(!firstCategory.subCategories.isEmpty)

        // 5. TransactionType이 올바르게 매핑되었는지 확인
        #expect(firstCategory.transactionType == .fixedExpance || firstCategory.transactionType == .varibleExpance || firstCategory.transactionType == .income)
    }
}
