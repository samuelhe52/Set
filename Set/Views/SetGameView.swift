//
//  SetGameView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var setGameVM: SetGameViewModel
    /// If no set is on screen, show an alert, telling user to deal 3 more cards.
    @State private var noSetOnScreen: Bool = false
    
    var body: some View {
        VStack {
            cardsWithChoiceAppearance
            status
            bottomBar
        }
    }
    
    @ViewBuilder
    var cardsWithChoiceAppearance: some View {
        if !setGameVM.gameStatus.gameEnded {
            cards.transition(.opacityScale)
            // Our transition must go here (inside if clause) for iOS 15 compatibility.
        }
    }
    
    var cards: some View {
        AspectVGrid(items: setGameVM.cards,
                    aspectRatio: Constants.Card.aspectRatio,
                    minWidth: Constants.Card.minWidth) { card in
            createCard(card)
                .contentShape(Rectangle()) // Ensure macOS users tap normally
                .onTapGesture { toggleChosen(card) }
                .padding(8)
        }
        .animation(.spring(duration: 0.3), value: setGameVM.cards.map { $0.id })
        .padding()
    }
    
    private func toggleChosen(_ card: SetCard) {
        let result = withAnimation(.smooth(duration: 0.3, extraBounce: 0.5)) {
            setGameVM.toggleChosen(card)
        }
        if result.shouldShake {
            startShaking(for: result.ids)
        }
    }
    
    @ViewBuilder
    var status: some View {
        if setGameVM.gameStatus.gameEnded {
            gameEndedScreen.transition(.opacityScale)
        } else {
            remainingCardCount.transition(.opacityScale)
        }
    }
    
    var remainingCardCount: some View {
        Text("Remaining: \(81 - setGameVM.discardedCards.count)")
            .font(.title3)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .scale(1.2)
                    .fill(.blue.lighter)
                    .opacity(0.7)
            }
    }
    
    @ViewBuilder
    var gameEndedScreen: some View {
        let reason = setGameVM.gameStatus.endReason
        let duration = setGameVM.gameStatus.duration ?? 0
        VStack {
            Text("🎉 You've Won! 🎉")
                .font(.largeTitle)
                .padding()
            Text("\(reason?.description ?? "")")
                .font(.title2)
            Text("Time Taken: \(duration, specifier: "%.2f") seconds")
                .font(.body)
        }
        .foregroundStyle(.purple)
    }

    var bottomBar: some View {
        HStack {
            newGame
            if !setGameVM.gameStatus.gameEnded {
                Spacer()
                hint
                Spacer()
                dealThreeMoreCards
                /// For debugging only!!!
//                Button(action: { setGameVM.showEndScreen() }, label: { Text("End Game") })
                /// For debugging only!!!
            }
        }
        .animation(.spring(duration: 0.4), value: setGameVM.gameStatus.gameEnded)
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
            withAnimation(.easeInOut(duration: 0.2)) {
                /// `giveHint()` returns false here, so we set the `noSetScreen` var to true.
                ///  Also, `giveHint()` will add IDs for cards that form a set into `setGameVM.hintCardIDs`
                if !setGameVM.giveHint() { noSetOnScreen.toggle() }
            }
        }) {
            Text("Hint")
        }
        .disabled(setGameVM.hintShown)
        .alert("Hint",
               isPresented: $noSetOnScreen,
               actions: {
            Button(role: .cancel, action: {}) { Text("Cancel") }
            dealThreeMoreCards
        }, message: { Text("No Set On Screen!") })
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
    
    @State private var shakingCardIDs: Set<SetCard.ID>?
    @State private var shakeTimer: Timer?
    
    private func determineShaking(for card: SetCard) -> Bool {
        if let shakingCardIDs {
            shakingCardIDs.contains(card.id)
        } else { false }
    }
    
    private func startShaking(for cardIDs: Set<SetCard.ID>?) {
        if let cardIDs {
            // Cancel any existing timer
            shakeTimer?.invalidate()
            // Set the cards to shake
            shakingCardIDs = cardIDs
            // After 0.2 seconds, cancel shaking
            shakeTimer = Timer.scheduledTimer(withTimeInterval: Constants.Shake.duration,
                                              repeats: false) { _ in
                shakingCardIDs = nil
            }
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

extension AnyTransition {
    static let opacityScale = AnyTransition
        .opacity
        .combined(with: .scale)
        .animation(.smooth(duration: 0.4))
}

#Preview {
    SetGameView(setGameVM: SetGameViewModel())
}
