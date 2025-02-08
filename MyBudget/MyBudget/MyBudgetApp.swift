//
//  MyBudgetApp.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/1/25.
//

import SwiftUI
import SwiftData

@main
struct MyBudgetApp: App {
    
    var sharedModelContainer: ModelContainer
    
    init() {
        do {
            // TODO: 임시 Configuration 으로 추후 변경
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            sharedModelContainer = try ModelContainer(for: Transaction.self, configurations: configuration)
        } catch {
            fatalError("ModelContainer 생성 실패 : \(error)")
        }
        
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
