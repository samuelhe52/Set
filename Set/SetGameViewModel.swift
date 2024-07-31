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
    }
    
    func unChooseAll() {
        for index in setGame.deck.indices {
            setGame.deck[index].isChosen = false
        }
    }
}
