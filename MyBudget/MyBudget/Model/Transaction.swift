//
//  Transaction.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/1/25.
//

import Foundation
import SwiftData

/// 가계부 앱에서 사용되는 **거래 내역** 모델
///
/// 수입 또는 지출 내역을 저장하며, 카테고리, 결제 수단, 메모 등의 정보를 포함한다.
/// ## Relationships
/// - `category` (1:N) → 각 거래는 하나의 `Category`에 속함.
/// - `subCategory` (1:N) → 특정 거래는 하나의 `SubCategory`를 가질 수 있음.
/// - `paymentMethod` (1:N) → 해당 거래의 결제 수단을 나타냄.
@Model
class Transaction {
    @Attribute(.unique) var id: UUID
    var type: TransactionType
    var amount: Double
    var date: Date
    var category: Category?
    var subCategory: SubCategory?
    var paymentMethod: PaymentMethodDetail
    var location: String?
    var memo: String?
    
    /// `Transaction` 객체를 초기화 하는 생성자
    /// - Parameters:
    ///     - id: Transaction 의 고유 ID
    ///     - type: 거래 유형 (수입, 고정 지출, 변동 지출)
    ///     - amount: 거래 금액
    ///     - date: 거래 발생 날짜
    ///     - category: 주요 카테고리 (식비, 교통비 등등)
    ///     - subCategory: 하위 카테고리 (외식비, 식자재, 배달 등등)
    ///     - paymentMethod: 우리 신용카드, 우리 체크카드, 현금 결제, 계좌이체 등등
    ///     - location: 수입원, 지출장소(회사명, 맥도날드, 스타벅스 등등)
    ///     - memo: 기타 거래 내역에 대한 추가 설명
    init(id: UUID, type: TransactionType, amount: Double, date: Date, category: Category, subCategory: SubCategory, paymentMethod: PaymentMethodDetail, location: String? = nil, memo: String? = nil) {
        self.id = id
        self.type = type
        self.amount = amount
        self.date = date
        self.category = category
        self.subCategory = subCategory
        self.paymentMethod = paymentMethod
        self.location = location
        self.memo = memo
    }
}

/// 거래의 유형을 나타내는 `enum`.
///
/// ## 종류:
/// - `income` (`수입`) → 사용자의 수입 (예: 월급, 용돈)
/// - `fixedExpense` (`고정 지출`) → 매월 일정하게 지출되는 비용 (예: 월세, 보험료)
/// - `variableExpense` (`변동 지출`) → 변동적으로 발생하는 지출 (예: 식비, 쇼핑)
enum TransactionType: Int, Codable {
    case income
    case fixedExpance
    case varibleExpance
    
    static func fromKoreanName(_ name: String) -> TransactionType? {
        switch name {
        case "수입": return .income
        case "고정 지출": return .fixedExpance
        case "변동 지출": return .varibleExpance
        default: return nil
        }
    }
}
