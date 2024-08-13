//
//  SetGameViewModel.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import Foundation

class SetGameViewModel: ObservableObject {
    @Published private var setGame = SetGame()
    @Published var hintCardIDs: Set<UUID>?
    
    var cards: [SetCard] { setGame.cardsOnTable }
    var matchedCards: [SetCard] { setGame.matchedCards }
    var gameOver: Bool { setGame.gameOver }
    var gameStart: Date = Date()
    // The time taken for a whole game.
    var timeTaken: TimeInterval?
    var hintShown: Bool {
        !Set(cards.map { $0.id })
            .intersection(hintCardIDs ?? [])
            .isEmpty
    }
        
    private var maxVisibleCardCount: Int { setGame.deck.count }
    var canDealMoreCards: Bool { !setGame.deck.isEmpty }
    
    // MARK: - Intent
    
    /// - Returns: The UUIDs of cards that failed to form a set, if any.
    func toggleChosen(_ card: SetCard) -> Set<UUID>? {
        return setGame.toggleChosen(card)
    }
    
    func startNewGame() {
        setGame = SetGame()
        gameStart = Date()
    }
    
    func dealThreeMoreCards() {
        setGame.dealThreeMoreCards()
    }
    
    ///  - Returns: Returns `false` if there is no valid set on screen, otherwise returns `true`.
    ///  - Adds UUIDs of the cards that form a set into `hintCardIDs`, if any.
    func giveHint() -> Bool {
        if let validSetCardIDs = SetGame.findSet(in: cards) {
            hintCardIDs = validSetCardIDs
            return true
        } else {
            return false
        }
    }
}
