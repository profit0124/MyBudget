//
//  TransacntionRepository.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/16/25.
//

import Foundation
import SwiftData

protocol TransactionRepository {
    func fetchTransaction() async throws -> [Transaction]
    func insertTransaction(_ transaction: Transaction) async throws
    func deleteTransaction(_ transaction: Transaction) async throws
    func updateTransacntio() async throws
}

final class TransactionRepositoryImplement: TransactionRepository {

    private var database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetchTransaction() async throws -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>()
        return try await database.fetch(descriptor)
    }
    
    func insertTransaction(_ transaction: Transaction) async throws {
        try await database.insert(transaction)
    }
    
    func deleteTransaction(_ transaction: Transaction) async throws {
        try await database.delete(transaction)
    }
    
    func updateTransacntio() async throws {
        do {
            try await database.saveForUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
}
