//
//  BudgetRepositoryTests.swift
//  MyBudgetTests
//
//  Created by Claude on 4/16/25.
//

import Testing
import Foundation
@testable import MyBudget

struct BudgetRepositoryTests {
    
    let repository: BudgetRepository
    let categoryBudgetRepository: CategoryBudgetRepository
    
    init() {
        let database = Database(isStoredInMemoryOnly: true)
        self.repository = BudgetRepositoryImplement(database: database)
        self.categoryBudgetRepository = CategoryBudgetRepositoryImplement(database: database)
    }

    @Test func testFetch() async {
        let budgets = try? await repository.fetchBudget()
        #expect(budgets != nil)
        #expect(budgets?.count == 0)
    }
    
    @Test func testInsert() async throws {
        // 현재 날짜 기준의 달(月) 생성
        let currentMonth = Calendar.current.startOfMonth(for: Date())
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
        
        // 카테고리 예산 객체 생성
        let categoryBudget1 = CategoryBudget(categoryName: "식비", limit: 300000)
        let categoryBudget2 = CategoryBudget(categoryName: "교통비", limit: 100000)
        
        // 첫 번째 예산 객체 생성 및 삽입
        let budget1 = Budget(
            month: currentMonth,
            totalLimit: 1000000,
            isCustom: true,
            categoryBudgets: [categoryBudget1, categoryBudget2]
        )
        try await repository.insertBudget(budget1)
        
        // 예산 조회 및 검증
        var budgets = try await repository.fetchBudget()
        #expect(budgets.count == 1)
        
        // 두 번째 예산 객체 생성 및 삽입
        let budget2 = Budget(
            month: nextMonth,
            totalLimit: 1200000,
            isCustom: false,
            categoryBudgets: []
        )
        try await repository.insertBudget(budget2)
        
        // 예산 조회 및 검증
        budgets = try await repository.fetchBudget()
        #expect(budgets.count == 2)
        
        // 첫 번째 예산 객체의 속성 검증
        let firstBudget = budgets.first(where: { Calendar.current.isDate($0.month, equalTo: currentMonth, toGranularity: .month) })
        #expect(firstBudget != nil)
        #expect(firstBudget?.totalLimit == 1000000)
        #expect(firstBudget?.isCustom == true)
        #expect(firstBudget?.categoryBudgets.count == 2)
    }
    
    @Test func testDelete() async throws {
        // 예산 객체 생성
        let currentMonth = Calendar.current.startOfMonth(for: Date())
        let categoryBudget = CategoryBudget(categoryName: "식비", limit: 300000)
        let budget = Budget(
            month: currentMonth,
            totalLimit: 1000000,
            isCustom: true,
            categoryBudgets: [categoryBudget]
        )
        
        // 예산 삽입
        try await repository.insertBudget(budget)
        var budgets = try await repository.fetchBudget()
        #expect(budgets.count == 1)
        
        // 예산 삭제
        try await repository.deleteBudget(budget)
        budgets = try await repository.fetchBudget()
        #expect(budgets.count == 0)
    }
    
    @Test func testUpdate() async throws {
        // 예산 객체 생성
        let currentMonth = Calendar.current.startOfMonth(for: Date())
        let categoryBudget = CategoryBudget(categoryName: "식비", limit: 300000)
        let budget = Budget(
            month: currentMonth,
            totalLimit: 1000000,
            isCustom: true,
            categoryBudgets: [categoryBudget]
        )
        
        // 예산 삽입
        try await repository.insertBudget(budget)
        
        // 예산 조회 및 수정
        let fetchedBudget = try await repository.fetchBudget().first!
        #expect(fetchedBudget.totalLimit == 1000000)
        
        // 예산 금액 변경
        fetchedBudget.totalLimit = 1200000
        try await repository.updateBudget()
        
        // 변경된 예산 조회 및 검증
        let updatedBudgets = try await repository.fetchBudget()
        #expect(updatedBudgets.count == 1)
        #expect(updatedBudgets.first!.id == budget.id)
        #expect(updatedBudgets.first!.totalLimit == 1200000)
        
        // 카테고리 예산 추가
        let newCategoryBudget = CategoryBudget(categoryName: "교통비", limit: 100000)
        fetchedBudget.categoryBudgets.append(newCategoryBudget)
        try await repository.updateBudget()
        
        // 변경된 예산 조회 및 검증
        let budgetsWithNewCategory = try await repository.fetchBudget()
        #expect(budgetsWithNewCategory.first!.categoryBudgets.count == 2)
    }
}

// 테스트 유틸리티 확장
extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}
