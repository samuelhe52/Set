//
//  ContentView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI

struct SetGameView: View {
    var body: some View {
        HStack {
            VStack {
                ForEach(SetCard.Shapes.allCases) { shape in
                    CardView(card: SetCard(shape: shape, shapeCount: .one, shading: .open, color: .purple))
                }
            }
            VStack {
                ForEach(SetCard.Shapes.allCases) { shape in
                    CardView(card: SetCard(shape: shape, shapeCount: .two, shading: .solid, color: .pink))
                }
            }
            VStack {
                ForEach(SetCard.Shapes.allCases) { shape in
                    CardView(card: SetCard(shape: shape, shapeCount: .three, shading: .striped, color: .blue))
                }
            }
        }
        .padding()
    }
}

#Preview {
    SetGameView()
}
