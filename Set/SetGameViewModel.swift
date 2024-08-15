//
//  SetGameViewModel.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import Foundation

class SetGameViewModel: ObservableObject {
    @Published private var setGame = SetGame()
    @Published var hintCardIDs: Set<SetCard.ID>?
    
    var cards: [SetCard] { setGame.cardsOnTable }
    var discardedCards: [SetCard] { setGame.discardedCards }
    
    private var gameStartTime: Date = Date()
    private var gameEndTime: Date?
    
    var gameStatus: (gameEnded: Bool, duration: TimeInterval?, endReason: SetGame.GameEndReason?) {
        if gameEndTime == nil && setGame.gameStatus.gameEnded {
            gameEndTime = Date()
        }
        let duration = gameEndTime?.timeIntervalSince(gameStartTime)
        
        return (setGame.gameStatus.gameEnded, duration, setGame.gameStatus.endReason)
    }
    
    var hintShown: Bool {
        !Set(cards.map { $0.id })
            .intersection(hintCardIDs ?? [])
            .isEmpty
    }
        
    private var maxVisibleCardCount: Int { setGame.deck.count }
    var canDealMoreCards: Bool { !setGame.deck.isEmpty }
    
    // MARK: - Intent
    
    /// - Returns: The IDs of cards that failed to form a set, if any.
    func toggleChosen(_ card: SetCard) -> (shouldShake: Bool, ids: Set<SetCard.ID>?) {
        return setGame.toggleChosen(card)
    }
    
    func startNewGame() {
        setGame = SetGame()
        gameStartTime = Date()
        gameEndTime = nil
    }
    
    func dealThreeMoreCards() {
        setGame.dealThreeMoreCards()
    }
    
    ///  - Returns: Returns `false` if there is no valid set on screen, otherwise returns `true`.
    ///  - Adds IDs of the cards that form a set into `hintCardIDs`, if any.
    func giveHint() -> Bool {
        if let validSetCardIDs = SetGame.findSet(in: cards) {
            hintCardIDs = validSetCardIDs
            return true
        } else {
            return false
        }
    }
    
    /// For debugging only!!!
    func showEndScreen() {
        setGame.endGame()
    }
    /// For debugging only!!!
}
