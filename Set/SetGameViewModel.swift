//
//  SetGameViewModel.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import Foundation

class SetGameViewModel: ObservableObject {
    @Published private var setGame = SetGame()
    @Published private(set) var cardsThatShouldShake: IndexSet?
    
    var cards: [SetCard] { setGame.cardsOnTable }
    var matchedCards: [SetCard] { setGame.matchedCards }
    
    private var maxVisibleCardCount: Int { setGame.deck.count }
    var canDealMoreCards: Bool { !setGame.deck.isEmpty }
    
    private var shakeTimer: Timer?
    private func startShaking(for cards: IndexSet) {
        // Cancel any existing timer
        shakeTimer?.invalidate()
        // Set the cards to shake
        self.cardsThatShouldShake = cards
        // After 0.5 seconds, cancel shaking
        shakeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            self.cardsThatShouldShake = nil
        }
    }
    
    // MARK: - Intent
    func toggleChosen(_ card: SetCard) {
        if let cardsThatShouldShake = setGame.toggleChosen(card) {
            startShaking(for: cardsThatShouldShake)
        }
    }
    
    func startNewGame() {
        setGame = SetGame()
    }
    
    func dealThreeMoreCards() {
        setGame.dealThreeMoreCards()
    }
}
