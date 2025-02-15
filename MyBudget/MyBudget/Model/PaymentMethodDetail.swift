//
//  PaymentMethodDetail.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/3/25.
//

import Foundation
import SwiftData

/// 거래 시 사용 가능한 결제 수단을 나타내는 `enum`.
///
/// ## 종류:
/// - `cash` (`현금`) → 현금 결제
/// - `creditCard` (`신용카드`) → 신용카드 결제
/// - `debitCard` (`체크카드`) → 체크카드 결제
/// - `bankTransfer` (`계좌이체`) → 계좌이체
enum PaymentMethod: String, CaseIterable, Codable {
    case cash = "현금"
    case creditCard = "신용카드"
    case debitCard = "체크카드"
    case bankTransfer = "계좌이체"

    // 결제 수단을 그룹별로 반환하는 함수
    static func groupedMethods() -> [(String, [PaymentMethod])] {
        return [
            ("현금", [.cash]),
            ("카드", [.creditCard, .debitCard]),
            ("계좌이체", [.bankTransfer])
        ]
    }
}

/// 특정한 결제 수단의 상세 정보를 저장하는 모델.
///
/// `Transaction`과 연결되어 있으며, 결제 방법을 구체적으로 정의함.
///
/// ## Relationships:
/// - `transactions` (1:N) → 해당 결제 수단을 사용한 거래 목록을 포함함.
@Model
class PaymentMethodDetail {
    @Attribute(.unique) var id: UUID = UUID()
    var type: PaymentMethod  // 카드, 현금, 계좌이체 중 하나
    var name: String?        // 카드명 (ex: 국민카드, 신한카드)
    var cashReceipt: Bool?   // 현금영수증 여부 (현금 결제 시)
    @Relationship(deleteRule: .cascade) var transactions: [Transaction]
    
    /// `PaymentMethodDetail` 객체를 초기화하는 생성자.
    /// - Parameters:
    ///   - type: 결제 수단 유형 (`현금`, `신용카드`, `체크카드`, `계좌이체`)
    ///   - name: 결제 수단의 이름 (예: `우리 신용카드`, `삼성 체크카드`) (기본값: `nil`)
    ///   - cashReceipt: 현금 영수증 발급 여부 (기본값: `nil`)
    ///   - transactions: 해당 결제 수단을 사용한 거래 목록 (기본값: 빈 배열)
    init(type: PaymentMethod,
         name: String? = nil,
         cashReceipt: Bool? = nil,
         transactions: [Transaction] = []
    ) {
        self.type = type
        self.name = name
        self.cashReceipt = cashReceipt
        self.transactions = transactions
    }
}
