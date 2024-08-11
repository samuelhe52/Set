//
//  ContentView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var setGameVM: SetGameViewModel

    var body: some View {
        VStack {
            cards
            Spacer()
            bottomBar
            Spacer(minLength: 20)
        }
    }
    
    var cards: some View {
        AspectVGrid(items: setGameVM.cards,
                    aspectRatio: 5/7,
                    minWidth: 80) { card in
            createCardView(card)
                .onTapGesture {
                    setGameVM.toggleChosen(card)
                }
                .padding(8)
        }
        .animation(.easeInOut, value: setGameVM.cards.count)
        .padding()
    }
    
    var status: some View {
        HStack {
            Text("Score: \(setGameVM.score)")
            Divider().frame(width: 10, height: 20)
            Text("Matched: \(setGameVM.matchedCards.count) / 81")
        }
        .font(.title3)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .scale(1.2)
                .fill(.blue.lighter)
                .opacity(0.7)
        }
    }
    
    var bottomBar: some View {
        VStack {
            HStack {
                status.padding()
            }
            HStack {
                newGame
                Spacer()
                dealThreeMoreCards
            }
        }
        .padding()
    }
    
    var newGame: some View {
        Button(action: { 
            setGameVM.startNewGame()
        }, label: {
            Text("New Game")
        })
    }
    
    var dealThreeMoreCards: some View {
        Button(action: { setGameVM.dealThreeMoreCards() }, label: {
            Text("3 More Cards")
        })
        .disabled(!setGameVM.canDealMoreCards)
    }
    
    @ViewBuilder
    private func createCardView(_ card: SetCard) -> some View {
        let shouldShake = determineCardShouldShake(card)
        
        CardView(card)
            .scaleEffect(card.isChosen ? 1.1 : 1)
            .animation(.smooth(duration: 0.25, extraBounce: 0.5), value: card.isChosen)
            .rotationEffect(.degrees(shouldShake ? 7 : 0))
            .animation(
                shouldShake ? .easeInOut(duration: 0.06).repeatForever() : .default,
                value: shouldShake
            )
    }
    
    private func determineCardShouldShake(_ card: SetCard) -> Bool {
        if let cardsThatShouldShake = setGameVM.cardsThatShouldShake {
            cardsThatShouldShake.contains(setGameVM.cards.firstIndex(of: card) ?? -1)
        } else {
            false
        }
    }
}

#Preview {
    SetGameView(setGameVM: SetGameViewModel())
}
