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
        let testCard1 = SetCard(shape: .diamond, shapeCount: .one, shading: .striped, color: .pink)
//        let testCard2 = SetCard(shape: .diamond, shapeCount: .two, shading: .striped, color: .pink)
//        let testCard3 = SetCard(shape: .diamond, shapeCount: .two, shading: .striped, color: .pink)
        
        let testCard2 = SetCard(shape: .oval, shapeCount: .one, shading: .solid, color: .blue)
        let testCard3 = SetCard(shape: .squiggle, shapeCount: .three, shading: .open, color: .purple)
        
        XCTAssert(SetGame.isValidSet(card1: testCard1, card2: testCard2, card3: testCard3) == false)
    }

    func testPerformanceExample() throws {
        let testCard1 = SetCard(shape: .diamond, shapeCount: .one, shading: .striped, color: .pink)
        let testCard2 = SetCard(shape: .oval, shapeCount: .two, shading: .solid, color: .blue)
        let testCard3 = SetCard(shape: .squiggle, shapeCount: .three, shading: .open, color: .purple)
        
        // Performance measurement
        measure {
            XCTAssert(SetGame.isValidSet(card1: testCard1, card2: testCard2, card3: testCard3) == true)
        }
    }
}
