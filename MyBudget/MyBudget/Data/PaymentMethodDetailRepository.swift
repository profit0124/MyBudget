//
//  PaymentMethodDetailRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/16/25.
//

import Foundation
import SwiftData

protocol PaymentMethodDetailRepository {
    func fetchPaymentMethodDetail() async throws -> [PaymentMethodDetail]
    func insertPaymentMethodDetail(_ paymentMethodDetail: PaymentMethodDetail) async throws
    func deletePaymentMethodDetail(_ paymentMethodDetail: PaymentMethodDetail) async throws
    func updatePaymentMethodDetail() async throws
}

final class PaymentMethodDetailRepositoryImplement: PaymentMethodDetailRepository {
    
    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchPaymentMethodDetail() async throws -> [PaymentMethodDetail] {
        let descriptor = FetchDescriptor<PaymentMethodDetail>()
        return try await database.fetch(descriptor)
    }
    
    func insertPaymentMethodDetail(_ paymentMethodDetail: PaymentMethodDetail) async throws {
        try await database.insert(paymentMethodDetail)
    }
    
    func deletePaymentMethodDetail(_ paymentMethodDetail: PaymentMethodDetail) async throws {
        try await database.delete(paymentMethodDetail)
    }
    
    func updatePaymentMethodDetail() async throws {
        do {
            try await database.saveForUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
}
