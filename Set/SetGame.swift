//
//  SetGame.swift
//  Set
//
//  Created by Samuel He on 2024/7/6.
//

import Foundation

struct SetGame {
    var deck: [SetCard] = createDeck()
    var matchedCards:[SetCard] = []
    private(set) var score: Int = 0
    
    mutating func toggleChosenState(_ card: SetCard) {
        guard let chosenCardIndex = deck.firstIndex(where: { $0.id == card.id }) else {
            print("No such card in deck!")
            return
        }
                
        if deck.chosenCardCount < 3 || deck.chosenCards.contains(deck[chosenCardIndex]) {
            deck[chosenCardIndex].isChosen.toggle()
            
            switch deck.chosenCardCount {
            case 3:
                if deck.chosenCards.isValidSet {
                    print("Matched: \(deck.chosenCards.map({ $0.description }).joined(separator: " "))")
                    
                    matchedCards.append(contentsOf: deck.chosenCards)
                    deck.remove(atOffsets: deck.chosenCardIndices)
                    deck.chosenCardIndices.forEach { index in
                        deck[index].isChosen = false
                    }
                    score += 1
                } else {
                    print("Match failed: \(deck.chosenCards.map({ $0.description }).joined(separator: " "))")
                }
            default:
                break
            }
            
        } else {
            print("No more than 3 cards can be chosen.")
        }
    }
        
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

extension Array where Element == SetCard {
    var chosenCards: [SetCard] { self.lazy.filter { $0.isChosen } }
    var chosenCardCount: Int { chosenCards.count }
    var chosenCardIndices: IndexSet {
        return IndexSet(
            self.enumerated()
                .filter { $1.isChosen }
                .map { $0.offset }
        )
    }
    var isValidSet: Bool { SetGame.isValidSet(chosenCards) }
}
