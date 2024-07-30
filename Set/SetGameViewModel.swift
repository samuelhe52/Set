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
    
    var cards: [SetCard] {
        return setGame.deck
    }
    
    // MARK: - Intent
    func choose(_ card: SetCard) {
        setGame.chooseCard(card)
    }

}
