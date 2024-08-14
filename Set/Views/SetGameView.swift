//
//  ContentView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var setGameVM: SetGameViewModel
    /// If no set is on screen, show an alert, telling user to deal 3 more cards.
    @State var noSetOnScreen: Bool = false
    @State var shakingCardIDs: Set<UUID>?
    @State var shakeTimer: Timer?

    var body: some View {
        VStack {
            if !setGameVM.gameEndStatus.gameEnded {
                cards
            }
            status
            bottomBar
        }
    }
    
    var cards: some View {
        AspectVGrid(items: setGameVM.cards,
                    aspectRatio: Constants.Card.aspectRatio,
                    minWidth: Constants.Card.minWidth) { card in
            createCard(card)
                .onTapGesture {
                    if let shouldShakeCardIDs = setGameVM.toggleChosen(card) {
                        startShaking(for: shouldShakeCardIDs)
                    }
                }
                .padding(8)
        }
        .animation(.spring(duration: 0.3), value: setGameVM.cards)
        .transition(
            .opacity
            .combined(with: .scale)
            .animation(.smooth(duration: 0.4))
        )
        .padding()
    }
    
    var status: some View {
        Group {
            if setGameVM.gameEndStatus.gameEnded {
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
            .transition(
                .opacity
                .combined(with: .scale)
                .animation(.smooth(duration: 0.4))
            )
    }
    
    @ViewBuilder
    var gameOverScreen: some View {
        let reason = setGameVM.gameEndStatus.reason!
        VStack {
            Text("🎉 Game Over 🎉")
                .font(.largeTitle)
                .padding()
            Text("\(reason.description)")
                .font(.title2)
            Text("Time Taken: \(setGameVM.timeTaken ?? 0, specifier: "%.2f") seconds")
                .font(.title3)
        }
        .foregroundStyle(.purple)
        .transition(
            .opacity
            .combined(with: .scale)
            .animation(.smooth(duration: 0.4))
        )
    }
    // It seems that the transition doesn't work on iOS 15...
    var bottomBar: some View {
        HStack {
            newGame
            if !setGameVM.gameEndStatus.gameEnded {
                Spacer()
                hint
                Spacer()
                dealThreeMoreCards
            }
        }
        .animation(.spring(duration: 0.5, bounce: 0.2),
                   value: setGameVM.gameEndStatus.gameEnded)
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
            /// `giveHint()` returns false here, so we set the `noSetScreen` var to true.
            ///  Also, `giveHint()` will add IDs for cards that form a set into `setGameVM.hintCardIDs`
            if !setGameVM.giveHint() { noSetOnScreen.toggle() }
        }) {
            Text("Hint")
        }
        .disabled(setGameVM.hintShown)
        .alert("No Set On Screen!",
               isPresented: $noSetOnScreen,
               actions: {
            Button(role: .cancel, action: {}) { Text("Cancel") }
            dealThreeMoreCards
        })
    }
    
    @ViewBuilder
    private func createCard(_ card: SetCard) -> some View {
        let shaking = determineShaking(for: card)
        let base = CardView(card)
        let baseColor = base.baseColor
        base
            .fluidGradientOverlay(
                        color: baseColor,
                        clipShape: RoundedRectangle(cornerRadius: 15),
                        isVisible: determineShowHint(for: card))
            .scaleEffect(card.isChosen ? Constants.Card.chosenCardScaleFactor : 1)
            .animation(.easeInOut(duration: 0.2), value: determineShowHint(for: card))
            .animation(.smooth(duration: 0.3, extraBounce: 0.5), value: card.isChosen)
            .shakeEffect(shaking,
                         singleShakeDuration: Constants.Shake.singleShakeDuration)
    }
    
    private func determineShowHint(for card: SetCard) -> Bool {
        if let hintCardIDs = setGameVM.hintCardIDs {
            hintCardIDs.contains(card.id)
        } else {
            false
        }
    }
    
    private func determineShaking(for card: SetCard) -> Bool {
        if let shakingCardIDs {
            shakingCardIDs.contains(card.id)
        } else {
            false
        }
    }
    
    private func startShaking(for cards: Set<UUID>) {
        // Cancel any existing timer
        shakeTimer?.invalidate()
        // Set the cards to shake
        shakingCardIDs = cards
        // After 0.2 seconds, cancel shaking
        shakeTimer = Timer.scheduledTimer(withTimeInterval: Constants.Shake.duration, repeats: false) { _ in
            shakingCardIDs = nil
        }
    }
    
    struct Constants {
        struct Card {
            static let aspectRatio: CGFloat = 5/7
            static let minWidth: CGFloat = 80
            static let chosenCardScaleFactor: CGFloat = 1.1
        }
        struct Shake {
            // The rotation angle used in the shake effect, divided by 10.
            static let intensity: CGFloat = 0.7
            static let singleShakeDuration: TimeInterval = 0.06
            static let duration: TimeInterval = 0.2
        }
    }
}

#Preview {
    SetGameView(setGameVM: SetGameViewModel())
}
