//
//  PaymentMethodDetail.swift
//  MyBudget
//
//  Created by Sooik Kim on 2/3/25.
//

import Foundation
import SwiftData

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

@Model
class PaymentMethodDetail {
    @Attribute(.unique) var id: UUID = UUID()
    var type: PaymentMethod  // 카드, 현금, 계좌이체 중 하나
    var name: String?        // 카드명 (ex: 국민카드, 신한카드)
    var cashReceipt: Bool?   // 현금영수증 여부 (현금 결제 시)

    init(type: PaymentMethod, name: String? = nil, cashReceipt: Bool? = nil) {
        self.type = type
        self.name = name
        self.cashReceipt = cashReceipt
    }
}
