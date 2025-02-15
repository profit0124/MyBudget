//
//  SubCategory.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/3/25.
//

import Foundation
import SwiftData

/// 가계부 앱에서 사용되는 **하위 카테고리 (SubCategory)** 모델.
///
/// `Category`의 세부 항목을 정의하여 거래를 더 구체적으로 분류할 수 있도록 합니다.
///
/// 예시 (부모 카테고리: `식비`):
/// - `외식비
/// - `식자재
/// - `배달음식
///
/// ## Relationships
/// - `parentCategory` (N:1) → 각 하위 카테고리는 하나의 `Category`에 속합니다.
/// - `transactions` (1:N) → 하나의 하위 카테고리는 여러 개의 거래(Transaction)과 연결될 수 있습니다.
@Model
class SubCategory {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    @Relationship(inverse: \Category.subCategories) var parentCategory: Category
    @Relationship(deleteRule: .cascade) var transactions: [Transaction]

    init(name: String,
         parentCategory: Category,
         transactions: [Transaction] = []
    ) {
        self.name = name
        self.parentCategory = parentCategory
        self.transactions = transactions
    }
}
