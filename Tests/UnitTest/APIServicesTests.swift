//
//  APIServicesTests.swift
//  Tests
//
//  Created by FoxxFire on 20.07.2025.
//

import XCTest

@testable import Test

final class APIServicesTests: XCTestCase {

    func testFetchProductsSuccess() {
        let expectation = self.expectation(description: "Products fetched")
        let apiService = APIService()

        apiService.fetchProducts { products in
            XCTAssertNotNil(products)
            XCTAssertFalse(products!.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testFetchProductsInvalidURL() {
        let expectation = self.expectation(description: "Should return nil due to invalid URL")

        let invalidAPI = APIService(urlString: "ht!tp://bad_url")

        invalidAPI.fetchProducts { products in
            XCTAssertNil(products, "Ожидался nil, так как URL некорректен")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}

