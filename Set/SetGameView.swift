//
//  ContentView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var setGame: SetGameViewModel
    @State private var cardsThatShouldShake: IndexSet?
    @State private var shakeTimer: Timer?

    var body: some View {
        VStack {
            cards
            HStack {
                Spacer()
                score
                Spacer()
                newGame
                Spacer()
            }
            .padding()
            Spacer(minLength: 20)
        }
    }
    
    var cards: some View {
        AspectVGrid(items: setGame.cards.prefix(24), aspectRatio: 5/7, minWidth: 80) { card in
            CardView(card, shouldShake: (cardsThatShouldShake?.contains(setGame.cards.firstIndex(of: card) ?? -1)) ?? false)
                .onTapGesture {
                    if let cardsThatShouldShake = setGame.toggleChosen(card) {
                        startShakeAnimation(for: cardsThatShouldShake)
                    }
                }
                .padding(8)
        }
        .padding()
    }
    
    var score: some View {
        Text("Score: \(setGame.score)")
            .font(.title3)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .scale(1.2)
                    .fill(.blue.lighter)
                    .opacity(0.7)
            }
    }
    
    var newGame: some View {
        Button(action: { setGame.startNewGame() }, label: {
            Text("New Game")
        })
    }
    
    private func startShakeAnimation(for cards: IndexSet) {
        // Cancel any existing timer
        shakeTimer?.invalidate()
        // Set the cards to shake
        self.cardsThatShouldShake = cards
        // After 0.5 seconds, cancel shaking
        shakeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            self.cardsThatShouldShake = nil
        }
    }
}

#Preview {
    SetGameView(setGame: SetGameViewModel())
}
