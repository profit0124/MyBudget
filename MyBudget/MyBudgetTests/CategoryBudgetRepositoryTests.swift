//
//  CategoryBudgetRepositoryTests.swift
//  MyBudgetTests
//
//  Created by Claude on 4/16/25.
//

import Testing
import Foundation
@testable import MyBudget

struct CategoryBudgetRepositoryTests {
    
    let repository: CategoryBudgetRepository
    
    init() {
        let database = Database(isStoredInMemoryOnly: true)
        self.repository = CategoryBudgetRepositoryImplement(database: database)
    }

    @Test func testFetch() async {
        let categoryBudgets = try? await repository.fetchCategoryBudget()
        #expect(categoryBudgets != nil)
        #expect(categoryBudgets?.count == 0)
    }
    
    @Test func testInsert() async throws {
        // 카테고리 예산 객체 생성
        let categoryBudget1 = CategoryBudget(categoryName: "식비", limit: 300000)
        let categoryBudget2 = CategoryBudget(categoryName: "교통비", limit: 100000)
        
        // 첫 번째 카테고리 예산 삽입
        try await repository.insertCategoryBudget(categoryBudget1)
        var categoryBudgets = try await repository.fetchCategoryBudget()
        #expect(categoryBudgets.count == 1)
        
        // 두 번째 카테고리 예산 삽입
        try await repository.insertCategoryBudget(categoryBudget2)
        categoryBudgets = try await repository.fetchCategoryBudget()
        #expect(categoryBudgets.count == 2)
        
        // 특정 카테고리 예산 검증
        let foodBudget = categoryBudgets.first(where: { $0.categoryName == "식비" })
        #expect(foodBudget != nil)
        #expect(foodBudget?.limit == 300000)
        
        let transportBudget = categoryBudgets.first(where: { $0.categoryName == "교통비" })
        #expect(transportBudget != nil)
        #expect(transportBudget?.limit == 100000)
    }
    
    @Test func testDelete() async throws {
        // 카테고리 예산 객체 생성 및 삽입
        let categoryBudget = CategoryBudget(categoryName: "식비", limit: 300000)
        try await repository.insertCategoryBudget(categoryBudget)
        
        // 삽입 확인
        var categoryBudgets = try await repository.fetchCategoryBudget()
        #expect(categoryBudgets.count == 1)
        
        // 카테고리 예산 삭제
        try await repository.deleteCategoryBudget(categoryBudget)
        categoryBudgets = try await repository.fetchCategoryBudget()
        #expect(categoryBudgets.count == 0)
    }
    
    @Test func testUpdate() async throws {
        // 카테고리 예산 객체 생성 및 삽입
        let categoryName = "식비"
        let initialLimit = 300000.0
        let categoryBudget = CategoryBudget(categoryName: categoryName, limit: initialLimit)
        try await repository.insertCategoryBudget(categoryBudget)
        
        // 삽입된 객체 조회
        let fetchedCategoryBudget = try await repository.fetchCategoryBudget().first!
        #expect(fetchedCategoryBudget.categoryName == categoryName)
        #expect(fetchedCategoryBudget.limit == initialLimit)
        
        // 객체 속성 변경
        let newLimit = 350000.0
        fetchedCategoryBudget.limit = newLimit
        try await repository.updateCategoryBudget()
        
        // 변경사항 조회 및 검증
        let updatedCategoryBudgets = try await repository.fetchCategoryBudget()
        #expect(updatedCategoryBudgets.count == 1)
        #expect(updatedCategoryBudgets.first!.id == categoryBudget.id)
        #expect(updatedCategoryBudgets.first!.categoryName == categoryName)
        #expect(updatedCategoryBudgets.first!.limit == newLimit)
        #expect(updatedCategoryBudgets.first!.limit != initialLimit)
        
        // 카테고리명 변경
        let newCategoryName = "외식비"
        fetchedCategoryBudget.categoryName = newCategoryName
        try await repository.updateCategoryBudget()
        
        // 변경사항 조회 및 검증
        let categoryNameChangedBudgets = try await repository.fetchCategoryBudget()
        #expect(categoryNameChangedBudgets.first!.categoryName == newCategoryName)
        #expect(categoryNameChangedBudgets.first!.categoryName != categoryName)
    }
    
    @Test func testIdUniqueness() async throws {
        // 동일한 카테고리명을 가진 두 개의 객체 생성
        let categoryName = "식비"
        let budget1 = CategoryBudget(categoryName: categoryName, limit: 300000)
        let budget2 = CategoryBudget(categoryName: categoryName, limit: 400000)
        
        // 두 객체 모두 삽입
        try await repository.insertCategoryBudget(budget1)
        try await repository.insertCategoryBudget(budget2)
        
        // 조회 및 검증
        let categoryBudgets = try await repository.fetchCategoryBudget()
        #expect(categoryBudgets.count == 2)
        
        // ID가 서로 다른지 검증
        let ids = categoryBudgets.map { $0.id }
        #expect(Set(ids).count == 2)
        
        // 동일한 카테고리명이 두 개 있는지 검증
        let categoryNames = categoryBudgets.map { $0.categoryName }
        let categoryNameCount = categoryNames.filter { $0 == categoryName }.count
        #expect(categoryNameCount == 2)
    }
}
