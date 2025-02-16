//
//  SubCategoryRepositoryTests.swift
//  MyBudgetTests
//
//  Created by Sooik Kim on 2/16/25.
//

import Testing
@testable import MyBudget

struct SubCategoryRepositoryTests {
    
    let repository: SubCategoryRepository
    
    init() {
        let database = Database(isStoredInMemoryOnly: true)
        self.repository = SubCategoryRepositoryImplement(database: database)
    }

    @Test func testFetch() async {
        let categories = try? await repository.fetchSubCategory()
        #expect(categories != nil)
        #expect(categories?.count == 0)
    }
    
    @Test func testInsert() async throws {
        let category = Category(name: "ParentCategory")
        let subCategory1 = SubCategory(name: "SubCategory1", parentCategory: category)
        let subCategory2 = SubCategory(name: "SubCategory2", parentCategory: category)
        
        try await repository.insertSubCategory(subCategory1)
        var subCategories = try await repository.fetchSubCategory()
        #expect(subCategories.count == 1)
        try await repository.insertSubCategory(subCategory2)
        subCategories = try await repository.fetchSubCategory()
        #expect(subCategories.count == 2)
    }
    
    @Test func testDelete() async throws {
        let category = Category(name: "ParentCategory")
        let subCategory3 = SubCategory(name: "SubCategory3", parentCategory: category)
        try await repository.insertSubCategory(subCategory3)
        var subCategories = try await repository.fetchSubCategory()
        #expect(subCategories.count == 1)
        try await repository.deleteSubCategory(subCategory3)
        subCategories = try await repository.fetchSubCategory()
        #expect(subCategories.count == 0)
    }
    
    @Test func testUpdate() async throws {
        let category1 = Category(name: "ParentCategory1")
        let category2 = Category(name: "ParentCategory2")
        let subCategory = SubCategory(name: "Sub", parentCategory: category1)
        try await repository.insertSubCategory(subCategory)
        let category = try await repository.fetchSubCategory().first!
        #expect(category.parentCategory == category1)
        category.parentCategory = category2
        try await repository.updateSubCategory()
        let subCategories = try await repository.fetchSubCategory()
        #expect(subCategories.count == 1)
        #expect(subCategories.first!.id == subCategory.id)
        #expect(subCategories.first!.parentCategory == category2)
    }

}
