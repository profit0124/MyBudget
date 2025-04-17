//
//  SharedTests.swift
//  MyBudgetTests
//
//  Created by Sooik Kim on 2/22/25.
//

import Testing
import Foundation
@testable import MyBudget

struct SharedTests {

    @Test func testLoadRecomendedCategory() async throws {
        let resourceName = "RecomendedCategory"
        let ext = "json"
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: resourceName, withExtension: ext) else {
            throw NSError(
                        domain: NSCocoaErrorDomain,
                        code: NSFileReadNoSuchFileError, // 코드 260
                        userInfo: [NSLocalizedDescriptionKey: "\(resourceName).\(ext) 파일을 번들에서 찾을 수 없습니다."]
                    )
        }
        let jsonData = try Data(contentsOf: url)
        let result = try JSONDecoder().decode([TransactionTypeEntity].self, from: jsonData)
        #expect(result.count > 0)
    }

}
