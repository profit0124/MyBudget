//
//  PaymentMethodDetailRepositoryTests.swift
//  MyBudgetTests
//
//  Created by Sooik Kim on 2/16/25.
//

import Testing
@testable import MyBudget

struct PaymentMethodDetailRepositoryTests {
    
    let repository: PaymentMethodDetailRepository
    
    init() {
        let database = Database(isStoredInMemoryOnly: true)
        self.repository = PaymentMethodDetailRepositoryImplement(database: database)
    }

    @Test func testFetch() async {
        let paymentMethodDetails = try? await repository.fetchPaymentMethodDetail()
        #expect(paymentMethodDetails != nil)
        #expect(paymentMethodDetails?.count == 0)
    }
    
    @Test func testInsert() async throws {
        let paymentMethodDetail1 = PaymentMethodDetail(type: .creditCard, name: "우리카드")
        let paymentMethodDetail2 = PaymentMethodDetail(type: .bankTransfer, name: "카카오페이")
        try await repository.insertPaymentMethodDetail(paymentMethodDetail1)
        var paymentMethodDetails = try await repository.fetchPaymentMethodDetail()
        #expect(paymentMethodDetails.count == 1)
        try await repository.insertPaymentMethodDetail(paymentMethodDetail2)
        paymentMethodDetails = try await repository.fetchPaymentMethodDetail()
        #expect(paymentMethodDetails.count == 2)
    }
    
    @Test func testDelete() async throws {
        let paymentMethodDetail1 = PaymentMethodDetail(type: .creditCard, name: "우리카드")
        try await repository.insertPaymentMethodDetail(paymentMethodDetail1)
        var paymentMethodDetails = try await repository.fetchPaymentMethodDetail()
        #expect(paymentMethodDetails.count == 1)
        try await repository.deletePaymentMethodDetail(paymentMethodDetail1)
        paymentMethodDetails = try await repository.fetchPaymentMethodDetail()
        #expect(paymentMethodDetails.count == 0)
    }
    
    @Test func testUpdate() async throws {
        let cardName = "우리카드"
        let paymentMethodDetail1 = PaymentMethodDetail(type: .creditCard, name: cardName)
        try await repository.insertPaymentMethodDetail(paymentMethodDetail1)
        let paymentMethodDetail = try await repository.fetchPaymentMethodDetail().first!
        #expect(paymentMethodDetail.name == cardName)
        let newName = "현대카드"
        paymentMethodDetail.name = newName
        try await repository.updatePaymentMethodDetail()
        let paymentMethodDetails = try await repository.fetchPaymentMethodDetail()
        #expect(paymentMethodDetails.count == 1)
        #expect(paymentMethodDetails.first!.id == paymentMethodDetail1.id)
        #expect(paymentMethodDetails.first!.name != cardName)
        #expect(paymentMethodDetails.first!.name == newName)
    }
}
