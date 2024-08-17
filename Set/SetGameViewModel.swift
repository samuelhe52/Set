//
//  SetGameViewModel.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import Foundation

class SetGameViewModel: ObservableObject {
    @Published private var setGame = SetGame()
    
    var deck: [SetCard] { setGame.deck }
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
    
    /// For debugging only!!!
    func showEndScreen() {
        setGame.endGame()
    }
    /// For debugging only!!!
}
