//
//  SetGameViewModel.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import Foundation

class SetGameViewModel: ObservableObject {
    @Published private var setGame = SetGame()
    
    var cards: [SetCard] { setGame.cardsOnTable }
    var matchedCards: [SetCard] { setGame.matchedCards }
    var gameOver: Bool { setGame.gameOver }
    var gameStart: Date = Date()
    // The time taken for a whole game.
    var timeTaken: TimeInterval?
    var hintShown: Bool { !cards.filter { $0.showHint }.isEmpty }
    
    private var maxVisibleCardCount: Int { setGame.deck.count }
    var canDealMoreCards: Bool { !setGame.deck.isEmpty }
    
    // MARK: - Intent
    
    /// - Returns: The indices of cards that failed to form a set, if any.
    func toggleChosen(_ card: SetCard) -> IndexSet? {
        if gameOver {
            timeTaken = Date().timeIntervalSince(gameStart)
        }
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
    func giveHint() -> Bool {
        return setGame.giveHint()
    }
}
