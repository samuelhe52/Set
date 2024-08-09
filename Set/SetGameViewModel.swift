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
    func toggleChosen(_ card: SetCard) -> IndexSet? {
        return setGame.toggleChosen(card)
    }
    
    func startNewGame() {
        setGame = SetGameViewModel.createSetGame()
    }
}
