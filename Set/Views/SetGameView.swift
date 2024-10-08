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
    
    // MARK: - Constants
    struct Constants {
        struct Card {
            static let aspectRatio: CGFloat = 5/7
            static let minWidth: CGFloat = 80
            static let chosenCardScaleFactor: CGFloat = 1.1
        }
        
        struct Shake {
            // The rotation angle used in the shake effect, divided by 10.
            static let intensity: CGFloat = 0.9
            static let singleShakeDuration: TimeInterval = 0.05
            static let duration: TimeInterval = 0.2
        }
        
        struct Deal {
            static let deckWidth: CGFloat = 40
            static let duration: TimeInterval = 0.6
            static let delay: TimeInterval = 0.1
            static let waitTime: TimeInterval = 0.75
            static let additionalDelay: TimeInterval = 0.75
        }
        
        static let initialCardCount: Int = 12
        static let cardsPerDeal: Int = 3
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            cardsWithChoiceAppearance
            statusWithCardPiles
            bottomBar
        }
    }
    
    // MARK: - Displaying cards
    @ViewBuilder
    var cardsWithChoiceAppearance: some View {
        if !setGameVM.gameStatus.gameEnded {
            cards.transition(.opacityScale)
        }
    }
    
    // MARK: Cards
    var cards: some View {
        AspectVGrid(items: setGameVM.deck,
                    // Avoid animation hitches caused by
                    // dealtCardIDs.count being zero when launching a new game.
                    itemCount: max(dealtCardIDs.count, Constants.initialCardCount),
                    aspectRatio: Constants.Card.aspectRatio,
                    minWidth: Constants.Card.minWidth) { card in
            if isDealt(card) {
                createCard(card)
                    .matchedGeometryEffect(id: card.id, in: dealCardNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardCardNameSpace)
                    .onTapGesture { toggleChosen(card) }
                    .padding(8)
            }
        }
        .animation(dealAnimation, value: setGameVM.discardedCards)
        .onChange(of: setGameVM.deck.count) {
            let allCardIDs = Set(setGameVM.deck.map { $0.id })
            dealtCardIDs = dealtCardIDs.intersection(allCardIDs)
        }
        .padding(8)
    }
    
    private func toggleChosen(_ card: SetCard) {
        let (matched, ids) = withAnimation(.smooth(duration: 0.3, extraBounce: 0.5)) {
            setGameVM.toggleChosen(card)
        }
        // ids is not nil, indicating that 3 cards are chosen
        if !matched && ids != nil {
            startShaking(for: ids)
        }
        // Only replenish the cards if there are less than 12 cards on screen
        if matched && onScreenCardCount < 12 {
            deal(delayed: true)
        }
    }
    
    @ViewBuilder
    private func createCard(_ card: SetCard) -> some View {
        let shaking = determineShaking(for: card)
        let base = CardView(card)
        let baseColor = base.baseColor
        base
            .fluidGradientOverlay(
                color: baseColor,
                clipShape: ProportionalRoundedRectangle(),
                isVisible: determineShowHint(for: card))
            .scaleEffect(card.isChosen ? Constants.Card.chosenCardScaleFactor : 1)
            .shakeEffect(shaking,
                         singleShakeDuration: Constants.Shake.singleShakeDuration)
    }
    
    // MARK: - Status
    @ViewBuilder
    var statusWithCardPiles: some View {
        HStack {
            if !setGameVM.gameStatus.gameEnded &&
                setGameVM.discardedCards.count != 0 {
                discardPile
                    .transition(.opacityScale)
                    .padding(.horizontal)
            }
            Spacer()
            Group {
                if setGameVM.gameStatus.gameEnded {
                    gameEndedScreen.transition(.opacityScale)
                } else {
                    remainingCardCount.transition(.opacityScale)
                }
            }
            .padding(.horizontal)
            Spacer()
            if !setGameVM.gameStatus.gameEnded {
                deck
                    .transition(.opacityScale)
                    .padding(.horizontal)
            }
        }
        .animation(dealAnimation, value: setGameVM.discardedCards)
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
    
    // MARK: - Deck
    @Namespace private var dealCardNamespace
    
    var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card, covered: true)
                    .matchedGeometryEffect(id: card.id, in: dealCardNamespace)
                }
            .overlay(alignment: .center) { Text("Deal") }
        }
        .onAppear {
            // Dealing must be delayed here to prevent animation glitches
            Timer.scheduledTimer(withTimeInterval: Constants.Deal.waitTime,
                                 repeats: false) { _ in deal() }
        }
        .onTapGesture { deal() }
        .frame(width: Constants.Deal.deckWidth,
               height: Constants.Deal.deckWidth / Constants.Card.aspectRatio)
    }
    
    // MARK: - Dealing cards
    @State private var dealtCardIDs: Set<SetCard.ID> = []
            
    private func isDealt(_ card: SetCard) -> Bool {
        dealtCardIDs.contains(card.id)
    }
    
    private var onScreenCardCount: Int {
        dealtCardIDs.intersection(Set(setGameVM.deck.map { $0.id })).count
    }
    
    private var undealtCards: [SetCard] { setGameVM.deck.filter { !isDealt($0) } }
    
    private let dealAnimation: Animation = .spring(duration: Constants.Deal.duration)
    
    private func deal(delayed: Bool = false) {
        if dealtCardIDs.count == 0 {
            dealCards(count: Constants.initialCardCount)
        } else {
            dealCards(count: Constants.cardsPerDeal,
                      withAdditionalDelay: delayed ? Constants.Deal.additionalDelay : 0)
        }
    }
    
    private func dealCards(count: Int,
                           withAdditionalDelay addDelay: TimeInterval = 0) {
        var delay: TimeInterval = 0 + addDelay
        for card in undealtCards.prefix(count) {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealtCardIDs.insert(card.id)
                delay += Constants.Deal.delay
            }
        }
    }
    
    // MARK: - Discard pile
    @Namespace private var discardCardNameSpace
    
    var discardPile: some View {
        ZStack {
            ForEach(setGameVM.discardedCards) { card in
                CardView(card, covered: true)
                    .matchedGeometryEffect(id: card.id, in: discardCardNameSpace)
                    .frame(width: Constants.Deal.deckWidth,
                           height: Constants.Deal.deckWidth / Constants.Card.aspectRatio)
            }
        }
    }

    // MARK: - Bar at bottom
    var bottomBar: some View {
        HStack {
            newGame
            if !setGameVM.gameStatus.gameEnded {
                Spacer()
                hint.transition(.opacityScale)
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
            let gameJustEnded = setGameVM.gameStatus.gameEnded
            withAnimation {
                setGameVM.startNewGame()
            }
            dealtCardIDs.removeAll()
            if !gameJustEnded {
                deal()
            }
        }, label: {
            Text("New Game")
        })
    }
    
    // MARK: - Displaying hint
    var hint: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                /// `giveHint()` returns false here, so we set the `noSetScreen` var to true.
                ///  Also, `giveHint()` will add IDs for cards that form a set into `setGameVM.hintCardIDs`
                if !giveHint() { noSetOnScreen.toggle() }
            }
        }) {
            Text("Hint")
        }
        .disabled(hintShown)
        .alert("Hint",
               isPresented: $noSetOnScreen,
               actions: {
            Button(role: .cancel, action: {}) { Text("Cancel") }
            Button(action: { dealCards(count: 3) }) { Text("Three More Cards") }
        }, message: { Text("No Set On Screen!") })
    }
    
    var hintShown: Bool {
        !Set(dealtCardIDs)
            .intersection(hintCardIDs ?? [])
            .isEmpty
    }
    
    @State var hintCardIDs: Set<SetCard.ID>?
    
    private func giveHint() -> Bool {
        let dealtCards = setGameVM.deck.filter { dealtCardIDs.contains($0.id) }
        if let validSetCardIDs = SetGame.findSet(in: dealtCards) {
            hintCardIDs = validSetCardIDs
            return true
        } else {
            return false
        }
    }
    
    private func determineShowHint(for card: SetCard) -> Bool {
        if let hintCardIDs = hintCardIDs {
            hintCardIDs.contains(card.id)
        } else {
            false
        }
    }
    
    // MARK: - Shaking animation logic
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
}

// MARK: - Extensions
extension AnyTransition {
    static let opacityScale = AnyTransition
        .opacity
        .combined(with: .scale)
        .animation(.smooth(duration: 0.4))
}

#Preview {
    SetGameView(setGameVM: SetGameViewModel())
}
