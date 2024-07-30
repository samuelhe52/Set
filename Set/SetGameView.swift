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
        AspectVGrid(items: setGame.cards.shuffled().prefix(16), aspectRatio: 5/7, allRowsFilled: true) { card in
            CardView(card)
                .padding(5)
        }
        .padding()
    }
}

#Preview {
    SetGameView(setGame: SetGameViewModel())
}
