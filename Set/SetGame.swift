//
//  SetGame.swift
//  Set
//
//  Created by Samuel He on 2024/7/6.
//

import Foundation

struct SetGame {
    private(set) var deck: [SetCard] = createDeck()
    private(set) var discardedCards: [SetCard] = []
    
    // MARK: - Game status
    var gameStatus: (gameEnded: Bool, endReason: GameEndReason?) {
        if deck.isEmpty {
            return (true, endReason: .allCardsMatched)
        /// It has been mathematically proven that the maximum number of
        /// cards in a group in which no set exists is 20, so we use it as a
        /// threshold to avoid unnecassary computation.
        } else if deck.count <= 20 {
            if SetGame.findSet(in: deck) == nil {
                return (gameEnded: true, endReason: .noSetFound)
            } else {
                return (gameEnded: false, endReason: .none)
            }
        } else {
            return (gameEnded: false, endReason: .none)
        }
    }
        
    enum GameEndReason: CustomStringConvertible {
        case noSetFound
        case allCardsMatched
        
        var description: String {
            switch self {
            case .noSetFound:
                return "No more set on screen"
            case .allCardsMatched:
                return "All cards matched"
            }
        }
    }
    
    // MARK: - Game logic
    /// - Returns: Wether chosen cards form a set, and
    /// the IDs of cards chosen if there are three cards chosen
    mutating func toggleChosen(_ card: SetCard) -> (matched: Bool, ids: Set<SetCard.ID>?) {
        guard let chosenCardIndex = deck.firstIndex(where: { $0.id == card.id }) else {
            print("No such card in cardsOnTable!")
            return (false, nil)
        }
                
        if deck.chosenCardCount < 3 ||
            deck.chosenCards.contains(deck[chosenCardIndex]) {
            deck[chosenCardIndex].isChosen.toggle()
            let chosenCardsThisSession = deck.chosenCards
            if deck.chosenCardCount == 3 {
                defer {
                    deck.chosenCardIndices.forEach { index in
                        deck[index].isChosen = false
                    }
                }
                
                // Only return the ids if three cards are chosen
                if chosenCardsThisSession.isValidSet {
                    print("Matched: \(chosenCardsThisSession.map({ $0.description }).joined(separator: " "))")
                    discardedCards.insert(contentsOf: chosenCardsThisSession, at: 0)
                    deck.remove(atOffsets: deck.chosenCardIndices)
                    return (true, Set(chosenCardsThisSession.map { $0.id }))
                } else {
                    print("Match failed: \(chosenCardsThisSession.map({ $0.description }).joined(separator: " "))")
                    return (false, Set(chosenCardsThisSession.map { $0.id }))
                }
            } else {
                // not three cards chosen
                return (false, nil)
            }
        } else {
            print("No more than 3 cards can be chosen.")
            return (false, nil)
        }
    }
    
    /// For debugging only!!!
    mutating func endGame() {
        discardedCards.append(contentsOf: deck)
        deck.removeAll()
    }
    /// For debugging only!!!
        
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
    }
    
    static func findSet(in cards: [SetCard]) -> Set<SetCard.ID>? {
        for i in 0..<cards.count {
            for j in i+1..<cards.count {
                for k in j+1..<cards.count {
                    if SetGame.isValidSet([cards[i], cards[j], cards[k]]) {
                        return Set([cards[i].id, cards[j].id, cards[k].id])
                    }
                }
            }
        }
        return nil
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
