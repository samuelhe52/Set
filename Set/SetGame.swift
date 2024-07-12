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
                    tmpDeck.append(SetCard(shape: cardShape, shapeCount: number, shading: shading, color: .pink))
                }
            }
        }
        
        return tmpDeck
    }
    
    static func isValidSet(card1: SetCard, card2: SetCard, card3: SetCard) -> Bool {
        func allSameOrAllDifferent<T: Equatable>(a: T, b: T, c: T) -> Bool {
            return (a == b && b == c) || (a != b && b != c && a != c)
        }
        
        return
            allSameOrAllDifferent(a: card1.color, b: card2.color, c: card3.color) &&
            allSameOrAllDifferent(a: card1.shading, b: card2.shading, c: card3.shading) &&
            allSameOrAllDifferent(a: card1.shape, b: card2.shape, c: card3.shape) &&
            allSameOrAllDifferent(a: card1.shapeCount, b: card2.shapeCount, c: card3.shapeCount)
    }
}
