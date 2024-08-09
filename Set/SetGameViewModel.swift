//
//  SetGameViewModel.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import Foundation

class SetGameViewModel: ObservableObject {
    static func createSetGame() -> SetGame {
        return SetGame()
    }
    
    @Published private var setGame = createSetGame()
    
    var cards: [SetCard] { setGame.deck }
    var matchedCards: [SetCard] { setGame.matchedCards }
    
    var score: Int { setGame.score }
    
    // MARK: - Intent
    func toggleChosenState(_ card: SetCard) {
        setGame.toggleChosenState(card)
        if setGame.deck.contains(where: { $0.shouldBounce }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.setGame.deck[self.setGame.deck.firstIndex(of: card)!].shouldBounce = false
            }
        }
    }
    
    func startNewGame() {
        setGame = SetGameViewModel.createSetGame()
    }
}
