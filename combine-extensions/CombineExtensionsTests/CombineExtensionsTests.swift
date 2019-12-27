//
//  CombineExtensionsTests.swift
//  CombineExtensionsTests
//
//  Created by Kevin Cheng on 12/27/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import XCTest
import Combine
@testable import CombineExtensions

class CombineExtensionsTests: XCTestCase {

    func testUnwrap() {
        let testValue = 5
        let testOptional: Int? = testValue
        let expectInt = expectation(description: "test value")
        _ = Just(testOptional).unwrap().sink { (result) in
            XCTAssertEqual(result, testValue)
            expectInt.fulfill()
        }
        let testArray: [Int?] = [1, nil, 3]
        let expectedArray = [1, 3]
        var resultArray: [Int] = []
        let expectArray = expectation(description: "test sequence")
        _ = Publishers.Sequence(sequence: testArray)
            .unwrap()
            .sink { result in
                resultArray.append(result)
                if expectedArray == resultArray {
                    expectArray.fulfill()
                }
            }
        wait(for: [expectInt, expectArray], timeout: 2)                
    }

}
