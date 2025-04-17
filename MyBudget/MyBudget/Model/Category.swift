//
//  Category.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/3/25.
//

import Foundation
import SwiftData

/// 가계부 앱에서 사용되는 **거래 카테고리 (Category)** 모델.
///
/// 사용자가 거래를 기록할 때, 해당 거래가 어떤 유형인지 분류하는 역할을 합니다.
///
/// 예시:
/// - `식비
/// - `교통비
/// - `쇼핑
/// - `월세
/// - `여가
///
/// ## Relationships
/// - `subCategories` (1:N) → 하나의 카테고리는 여러 개의 하위 카테고리를 가질 수 있습니다.
/// - `transactions` (1:N) → 하나의 카테고리는 여러 개의 거래(Transaction)과 연결될 수 있습니다.
@Model
class Category {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var transactionType: TransactionType
    
    @Relationship(deleteRule: .cascade, inverse: \SubCategory.parentCategory) var subCategories: [SubCategory]
    @Relationship(deleteRule: .cascade, inverse: \Transaction.category) var transactions: [Transaction]

    init(name: String,
         transactionType: TransactionType,
         subCategories: [SubCategory] = [],
         transactions: [Transaction] = []
    ) {
        self.name = name
        self.transactionType = transactionType
        self.subCategories = subCategories
        self.transactions = transactions
    }
}
