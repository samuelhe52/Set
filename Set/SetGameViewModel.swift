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
    
    private var gameStartTime: Date = Date()
    private var gameEndTime: Date?
    
    var gameStatus: GameStatus {
        var duration: TimeInterval?
        let status = setGame.gameStatus
        if status.gameEnded {
            if gameEndTime == nil {
                gameEndTime = Date()
            }
            duration = gameEndTime?.timeIntervalSince(gameStartTime)
        }
        return GameStatus(
            status: status,
            duration: duration
        )
    }
    
    struct GameStatus {
        private let status: SetGame.GameStatus
        
        var gameEnded: Bool { status.gameEnded }
        let duration: TimeInterval?
        var endReason: SetGame.GameStatus.GameEndReason? { status.reason }
        
        init(status: SetGame.GameStatus, duration: TimeInterval?) {
            self.status = status
            self.duration = duration
        }
    }
    
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
        gameStartTime = Date()
        gameEndTime = nil
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
    
    /// For debugging only!!!
    func showEndScreen() {
        setGame.endGame()
    }
    /// For debugging only!!!
}
