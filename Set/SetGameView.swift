//
//  ContentView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var setGame: SetGameViewModel
    
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
        VStack {
            AspectVGrid(items: setGame.cards.prefix(4), aspectRatio: 5/7, allRowsFilled: true) { card in
                CardView(card)
                    .onTapGesture {
                        setGame.toggleChosenState(card)
                    }
                    .padding(5)
            }
            .padding()
            Spacer()
            AspectVGrid(items: setGame.matchedCards, aspectRatio: 5/7, allRowsFilled: true) { card in
                CardView(card)
                    .onTapGesture {
                        setGame.toggleChosenState(card)
                    }
                    .padding(5)
            }
            .padding()
        }
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
}

#Preview {
    SetGameView(setGame: SetGameViewModel())
}
