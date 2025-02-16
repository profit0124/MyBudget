//
//  ModelContextProvider.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/8/25.
//

import Foundation
import SwiftData

enum DatabaseError: Error {
    case insertSaveError
    case deleteSaveError
}

@ModelActor
actor Database {
    init(isStoredInMemoryOnly: Bool = false) {
        do {
            let scheme = Schema([Category.self])
            let configuration = ModelConfiguration(schema: scheme, isStoredInMemoryOnly: isStoredInMemoryOnly, allowsSave: true)
            let container = try ModelContainer(for: scheme, configurations: configuration)
            let context = ModelContext(container)
            self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
            self.modelContainer = container
        } catch {
            fatalError("fail to load database")
        }
    }
    
    public func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
        return try self.modelContext.fetch(descriptor)
    }
    
    public func insert(_ model: some PersistentModel) async throws {
        do {
            self.modelContext.insert(model)
            try self.modelContext.save()
        } catch {
            self.modelContext.delete(model)
            throw DatabaseError.insertSaveError
        }
    }
    
    public func delete(_ model: some PersistentModel) async throws {
        do {
            self.modelContext.delete(model)
            try self.modelContext.save()
        } catch {
            self.modelContext.insert(model)
            throw DatabaseError.deleteSaveError
        }
    }
    
    public func saveForUpdate() throws {
        try self.modelContext.save()
    }
}
