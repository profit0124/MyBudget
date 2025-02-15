//
//  CategoryView.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/15/25.
//

import SwiftUI

struct CategoryView: View {
    
    @State private var viewModel: CategoryViewModel
    
    init() {
        let database = Database(isStoredInMemoryOnly: true)
        let repository = CategoryRepositoryImplement(database: database)
        self._viewModel = .init(wrappedValue: .init(repository: repository))
    }
    
    
    var body: some View {
        VStack {
            List(viewModel.categories) { category in
                HStack {
                    Text(category.name)
                    Spacer()
                    Button {
                        Task {
                            await viewModel.send(.delete(category))
                        }
                    } label: {
                        Text("Delete")
                    }
                }
            }
            
            TextField("new name", text: $viewModel.newCategoryName)
            Button {
                Task {
                    await viewModel.send(.insert)
                }
            } label: {
                Text("Add")
            }

            
        }
    }
}

#Preview {
    CategoryView()
}
