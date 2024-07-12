//
//  ContentView.swift
//  Set
//
//  Created by Samuel He on 2024/6/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            VStack {
                ForEach(SetCard.Shapes.allCases) { shape in
                    CardView(card: SetCard(shape: shape, shapeCount: .one, shading: .solid, color: .purple))
                }
                .padding()
            }
            VStack {
                ForEach(SetCard.Shapes.allCases) { shape in
                    CardView(card: SetCard(shape: shape, shapeCount: .two, shading: .open, color: .pink))
                }
                .padding()
            }
            VStack {
                ForEach(SetCard.Shapes.allCases) { shape in
                    CardView(card: SetCard(shape: shape, shapeCount: .three, shading: .solid, color: .blue))
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
