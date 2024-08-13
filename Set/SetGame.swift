//
//  SetGame.swift
//  Set
//
//  Created by Samuel He on 2024/7/6.
//

import Foundation

struct SetGame {
    private(set) var deck: [SetCard]
    private(set) var matchedCards: [SetCard] = []
    private(set) var cardsOnTable: [SetCard]
    var gameOver: Bool { deck.isEmpty && cardsOnTable.isEmpty }
    
    init() {
//        self.deck = Array(SetGame.createDeck().prefix(12))
        self.deck = SetGame.createDeck()
        self.matchedCards = []
        self.cardsOnTable = Array(deck.prefix(12))
        deck.removeSubrange(0..<12)
    }
    
    /// - Returns: The indices of cards that failed to form a set, if any.
    mutating func toggleChosen(_ card: SetCard) -> IndexSet? {
        guard let chosenCardIndex = cardsOnTable.firstIndex(where: { $0.id == card.id }) else {
            print("No such card in cardsOnTable!")
            return nil
        }
                
        if cardsOnTable.chosenCardCount < 3 ||
            cardsOnTable.chosenCards.contains(cardsOnTable[chosenCardIndex]) {
            cardsOnTable[chosenCardIndex].isChosen.toggle()
            switch cardsOnTable.chosenCardCount {
            case 3:
                defer {
                    cardsOnTable.chosenCardIndices.forEach { index in
                        cardsOnTable[index].isChosen = false
                    }
                }
                
                if cardsOnTable.chosenCards.isValidSet {
                    print("Matched: \(cardsOnTable.chosenCards.map({ $0.description }).joined(separator: " "))")
                    
                    matchedCards.append(contentsOf: cardsOnTable.chosenCards)
                    cardsOnTable.remove(atOffsets: cardsOnTable.chosenCardIndices)
                    dealThreeMoreCards()
                } else {
                    print("Match failed: \(cardsOnTable.chosenCards.map({ $0.description }).joined(separator: " "))")
                    return cardsOnTable.chosenCardIndices
                }
            default:
                break
            }
            return nil
        } else {
            print("No more than 3 cards can be chosen.")
            return nil
        }
    }
    
    mutating func dealThreeMoreCards() {
        cardsOnTable.append(contentsOf: deck.prefix(3))
        if deck.count >= 3 {
            deck.removeSubrange(0..<3)
        }
    }
    
    ///  - Returns: Returns `false` if there is no valid set on screen, otherwise returns `true`.
    mutating func giveHint() -> Bool {
        if let validSetIndices = SetGame.findSet(in: cardsOnTable) {
            for index in validSetIndices {
                cardsOnTable[index].showHint = true
            }
            return true
        } else {
            return false
        }
    }
        
    // MARK: - static methods
    private static func createDeck() -> [SetCard]{
        var tmpDeck: Array<SetCard> = []
        
        for number in SetCard.ShapeCount.allCases {
            for cardShape in SetCard.CardShape.allCases {
                for shading in SetCard.CardShading.allCases {
                    for color in SetCard.CardColor.allCases {
                        tmpDeck.append(SetCard(shape: cardShape,
                                               shapeCount: number,
                                               shading: shading,
                                               color: color))
                    }
                }
            }
        }
        
        return tmpDeck.shuffled()
    }
    
    static func isValidSet(_ cards: [SetCard]) -> Bool {
        func allSameOrAllDifferent<T: Equatable>(a: T, b: T, c: T) -> Bool {
            return (a == b && b == c) || (a != b && b != c && a != c)
        }
        
        guard cards.count == 3 else {
            return false
        }
        
        return
            allSameOrAllDifferent(a: cards[0].color,
                                  b: cards[1].color,
                                  c: cards[2].color) &&
            allSameOrAllDifferent(a: cards[0].shading,
                                  b: cards[1].shading,
                                  c: cards[2].shading) &&
            allSameOrAllDifferent(a: cards[0].shape,
                                  b: cards[1].shape,
                                  c: cards[2].shape) &&
            allSameOrAllDifferent(a: cards[0].shapeCount,
                                  b: cards[1].shapeCount,
                                  c: cards[2].shapeCount)
//        return true
    }
    
    static func findSet(in cards: [SetCard]) -> IndexSet? {
        for i in 0..<cards.count {
            for j in i+1..<cards.count {
                for k in j+1..<cards.count {
                    if SetGame.isValidSet([cards[i], cards[j], cards[k]]) {
                        return [i, j, k]
                    }
                }
            }
        }
        return nil
    }
}

struct SetCard: Identifiable, CustomStringConvertible {
    private(set) var shape: CardShape
    private(set) var shapeCount: ShapeCount
    private(set) var shading: CardShading
    private(set) var color: CardColor
    
    var isChosen: Bool = false
    var showHint: Bool = false
    
    var id: UUID = UUID()
    var description: String { "A card with \(shapeCount.rawValue) \(color.description) \(shading.description) \(shape.description)(s)" }
        
    // MARK: - Enums for card properties
    
    enum CardShape: CustomStringConvertible, CaseIterable, Identifiable {
        case diamond, squiggle, oval
        
        var description: String {
            switch self {
            case .diamond: "diamond"
            case .squiggle: "squiggle"
            case .oval: "oval"
            }
        }
        
        var id: String { self.description }
    }

    enum ShapeCount: Int, CaseIterable {
        case one = 1, two, three
    }

    enum CardShading: CustomStringConvertible, CaseIterable {
        case solid, striped, open
        
        var description: String {
            switch self {
            case .solid: "solid"
            case .striped: "striped"
            case .open: "open"
            }
        }
    }
    
    enum CardColor: CustomStringConvertible, CaseIterable {
        case purple, pink, blue
        
        var description: String {
            switch self {
            case .purple: "purple"
            case .pink: "pink"
            case .blue: "blue"
            }
        }
    }
}

extension SetCard: Equatable {
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return
            lhs.color == rhs.color &&
            lhs.shading == rhs.shading &&
            lhs.shape == rhs.shape &&
            lhs.shapeCount == rhs.shapeCount
    }
}

extension Sequence where Element == SetCard {
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
