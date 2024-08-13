//
//  ContentView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI
import FluidGradient

struct SetGameView: View {
    @ObservedObject var setGameVM: SetGameViewModel

    var body: some View {
        VStack {
            if !setGameVM.gameOver {
                cards
            }
            status
            bottomBar
        }
        .preferredColorScheme(.dark)
    }
    
    var cards: some View {
        AspectVGrid(items: setGameVM.cards,
                    aspectRatio: 5/7,
                    minWidth: 80) { card in
            createCard(card)
                .onTapGesture {
                    setGameVM.toggleChosen(card)
                }
                .padding(8)
        }
        .animation(.easeInOut(duration: 0.4), value: setGameVM.cards)
        .padding()
    }
    
    var status: some View {
        Group {
            if setGameVM.gameOver {
                gameOverScreen
            } else {
                matchedCardCount
            }
        }
    }
    
    var matchedCardCount: some View {
        Text("Matched: \(setGameVM.matchedCards.count) / 81")
            .font(.title3)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .scale(1.2)
                    .fill(.blue.lighter)
                    .opacity(0.7)
            }
            .transition(.opacity.combined(with: .scale).animation(.smooth(duration: 0.4)))
    }
    
    var gameOverScreen: some View {
        VStack {
            Text("🎉 Game Over 🎉")
                .font(.largeTitle)
                .padding()
            Text("Time Taken: \(setGameVM.timeTaken ?? 0, specifier: "%.2f") seconds")
                .font(.title3)
        }
        .foregroundStyle(.purple)
        .transition(.opacity.combined(with: .scale).animation(.smooth(duration: 0.4)))
    }
    
    var bottomBar: some View {
        HStack {
            newGame
            if !setGameVM.gameOver {
                Spacer()
                hint
                Spacer()
                dealThreeMoreCards
            }
        }
        .animation(.spring(duration: 0.5, bounce: 0.2), value: setGameVM.gameOver)
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
        Button(action: { setGameVM.dealThreeMoreCards() }) {
            Text("3 More Cards")
        }
        .disabled(!setGameVM.canDealMoreCards)
    }
    
    var hint: some View {
        Button(action: {
            setGameVM.giveHint()
        }) {
            Text("Hint")
        }
    }
    
    @ViewBuilder
    func fluidGradient(color: Color, speed: Double = 0.3) -> some View {
        let colors: [Color] = [color.lightened(strength: 1), color, color.lightened(strength: 0.5)]
        
        FluidGradient(blobs: colors,
                      speed: speed)
    }
    
    @ViewBuilder
    private func createCard(_ card: SetCard) -> some View {
        let shouldShake = determineCardShouldShake(card)
        let base = CardView(card)
        let baseColor = base.baseColor
        base
            .overlay {
                fluidGradient(color: baseColor)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .blur(radius: 5)
                    .opacity((card.showHint) ? 1 : 0)
            }
            .scaleEffect(card.isChosen ? 1.1 : 1)
            .animation(.easeInOut(duration: 0.2), value: card.showHint)
            .animation(.smooth(duration: 0.3, extraBounce: 0.5), value: card.isChosen)
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
