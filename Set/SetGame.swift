//
//  SetGame.swift
//  Set
//
//  Created by Samuel He on 2024/7/6.
//

import Foundation

struct SetGame {
    var deck: [SetCard] = createDeck()
    
    
    // MARK: - static methods
    private static func createDeck() -> [SetCard]{
        var tmpDeck: Array<SetCard> = []
        
        for number in SetCard.ShapeCount.allCases {
            for cardShape in SetCard.Shapes.allCases {
                for shading in SetCard.Shadings.allCases {
                    for color in SetCard.CardColors.allCases {
                        tmpDeck.append(SetCard(shape: cardShape, shapeCount: number, shading: shading, color: color))
                    }
                }
            }
        }
        
        return tmpDeck
    }
    
    static func isValidSet(_ cards: [SetCard]) -> Bool {
        func allSameOrAllDifferent<T: Equatable>(a: T, b: T, c: T) -> Bool {
            return (a == b && b == c) || (a != b && b != c && a != c)
        }
        
        guard cards.count == 3 else {
            return false
        }
        
        return
            allSameOrAllDifferent(a: cards[0].color, b: cards[1].color, c: cards[2].color) &&
            allSameOrAllDifferent(a: cards[0].shading, b: cards[1].shading, c: cards[2].shading) &&
            allSameOrAllDifferent(a: cards[0].shape, b: cards[1].shape, c: cards[2].shape) &&
            allSameOrAllDifferent(a: cards[0].shapeCount, b: cards[1].shapeCount, c: cards[2].shapeCount)
    }
}
