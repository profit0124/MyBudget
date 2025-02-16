//
//  TransactionRepositoryTests.swift
//  MyBudgetTests
//
//  Created by Sooik Kim on 2/16/25.
//

import Testing
import Foundation
@testable import MyBudget

struct TransactionRepositoryTests {
    
    let repository: TransactionRepository
    // Casecade Rule Check
    let categoryRepository: CategoryRepository
    
    init() {
        let database = Database(isStoredInMemoryOnly: true)
        self.repository = TransactionRepositoryImplement(database: database)
        self.categoryRepository = CategoryRepositoryImplement(database: database)
    }

    @Test func testFetch() async {
        let categories = try? await repository.fetchTransaction()
        #expect(categories != nil)
        #expect(categories?.count == 0)
    }
    
    @Test func testInsert() async throws {
        let category = Category(name: "ParentCategory")
        let subCategory = SubCategory(name: "SubCategory", parentCategory: category)
        let paymentMethodDetail = PaymentMethodDetail(type: .creditCard, name: "우리카드")
        let transaction = Transaction(
            id: UUID(),
            type: .varibleExpance,
            amount: 20000,
            date: Date(),
            category: category,
            subCategory: subCategory,
            paymentMethod: paymentMethodDetail)
        try await repository.insertTransaction(transaction)
        let transactions = try await repository.fetchTransaction()
        #expect(transactions.count == 1)
    }
    
    @Test func testDelete() async throws {
        let category = Category(name: "ParentCategory")
        let subCategory = SubCategory(name: "SubCategory", parentCategory: category)
        let paymentMethodDetail = PaymentMethodDetail(type: .creditCard, name: "우리카드")
        let transaction = Transaction(
            id: UUID(),
            type: .varibleExpance,
            amount: 20000,
            date: Date(),
            category: category,
            subCategory: subCategory,
            paymentMethod: paymentMethodDetail)
        try await repository.insertTransaction(transaction)
        var transactions = try await repository.fetchTransaction()
        #expect(transactions.count == 1)
        try await repository.deleteTransaction(transaction)
        transactions = try await repository.fetchTransaction()
        #expect(transactions.count == 0)
    }
    
    @Test func testUpdate() async throws {
        let category = Category(name: "ParentCategory")
        let subCategory = SubCategory(name: "SubCategory", parentCategory: category)
        let paymentMethodDetail = PaymentMethodDetail(type: .creditCard, name: "우리카드")
        let transaction = Transaction(
            id: UUID(),
            type: .varibleExpance,
            amount: 20000,
            date: Date(),
            category: category,
            subCategory: subCategory,
            paymentMethod: paymentMethodDetail)
        try await repository.insertTransaction(transaction)
        let transaction1 = try await repository.fetchTransaction().first!
        #expect(transaction1.amount == 20000)
        transaction1.amount = 30000
        try await repository.updateTransacntio()
        let transaction2 = try await repository.fetchTransaction().first!
        #expect(transaction2.id == transaction1.id)
        #expect(transaction2.amount == 30000)
        #expect(transaction2.amount == transaction1.amount)
        // MARK: Check casecade delete rule 
        var categoires = try await categoryRepository.fetchCategory()
        #expect(categoires.count == 1)
        try await categoryRepository.deleteCategory(category)
        categoires = try await categoryRepository.fetchCategory()
        #expect(categoires.count == 0)
        let transactions = try await repository.fetchTransaction()
        #expect(transactions.count == 0)
    }
}
