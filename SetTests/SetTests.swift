//
//  SetTests.swift
//  SetTests
//
//  Created by Samuel He on 2024/6/30.
//

import XCTest
@testable import Set

final class SetTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let testCard = SetCard(shape: .diamond, number: .one, shading: .striped)
        
        print(testCard)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
