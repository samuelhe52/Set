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
        
        let card1 = SetCard(shape: .diamond, shapeCount: .two, shading: .striped, color: .blue)
        let card2 = SetCard(shape: .squiggle, shapeCount: .one, shading: .open, color: .pink)
        let card3 = SetCard(shape: .squiggle, shapeCount: .one, shading: .striped, color: .purple)
        let card4 = SetCard(shape: .squiggle, shapeCount: .three, shading: .open, color: .pink)
        let card5 = SetCard(shape: .squiggle, shapeCount: .two, shading: .solid, color: .purple)
        let card6 = SetCard(shape: .oval, shapeCount: .one, shading: .solid, color: .blue)
        let card7 = SetCard(shape: .squiggle, shapeCount: .one, shading: .striped, color: .pink)
        let card8 = SetCard(shape: .squiggle, shapeCount: .two, shading: .striped, color: .purple)
        let card9 = SetCard(shape: .squiggle, shapeCount: .two, shading: .striped, color: .blue)

        let allCards = [card1, card2, card3, card4, card5, card6, card7, card8, card9]

        func check(_ cards: [SetCard]) -> [SetCard]? {
            for i in 0..<cards.count {
                for j in i+1..<cards.count {
                    for k in j+1..<cards.count {
                        if SetGame.isValidSet([cards[i], cards[j], cards[k]]) {
                            return [cards[i], cards[j], cards[k]]
                        }
                    }
                }
            }
            
            return nil
        }
        
        if let cards = check(allCards) {
            print(cards)
        } else {
            print("None")
        }
    }

    func testCreateDeck() throws {
        // Performance measurement
        measure {
            
        }
    }
}
