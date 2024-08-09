//
//  CardView.swift
//  Set
//
//  Created by Samuel He on 2024/7/6.
//

import SwiftUI

/// Displays a certain Set game card with a rounded rectangle surrounding the shape(s).
struct CardView: View {
    let card: SetCard
    var shouldBounce: Bool
    
    init(_ card: SetCard, shouldBounce: Bool = false) {
        self.card = card
        self.shouldBounce = shouldBounce
    }
    
    // Card properties
    var shapeCount: Int { card.shapeCount.rawValue }
    var baseColor: Color {
        switch card.color {
        case .purple: .purple.darkened(strength: 0.1)
        case .pink: .pink.darkened(strength: 0.03)
        case .blue: .blue
        }
    }
    
    @ViewBuilder
    private var cardShape: some View {
        switch card.shape {
        case .diamond: applyShadingAndColor(Diamond())
        case .squiggle: applyShadingAndColor(Squiggle())
        case .oval: applyShadingAndColor(Oval())
        }
    }
    
    @ViewBuilder
    private func applyShadingAndColor<T: Shape>(_ shape: T) -> some View {
        switch card.shading {
        case .solid: shape
        case .striped: shape
                .verticalLinesOverlay(lineWidth: 2.5, lineSpacing: 10)
        case .open: shape.stroke(lineWidth: 2.5)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(gradient: baseColor.lighter.brightnessGradient,
                                       startPoint: .topTrailing,
                                       endPoint: .bottomLeading), 
                        lineWidth: 3.5)
                .aspectRatio(5/7, contentMode: .fit)
                .overlay(alignment: .center) {
                    VStack {
                        ForEach(0..<shapeCount, id: \.self) { _ in
                            cardShape
                                .aspectRatio(5/3, contentMode: .fit)
                                .foregroundStyle(LinearGradient(gradient: baseColor.lighter.brightnessGradient(contrast: 0.3),
                                                                startPoint: .topTrailing,
                                                                endPoint: .bottomLeading))
                        }
                    }
                    .padding()
                }
        }
        .scaleEffect(card.isChosen ? 1.1 : 1)
        .animation(.smooth(duration: 0.3, extraBounce: 0.5), value: card.isChosen)
        .scaleEffect(shouldBounce ? 1.1 : 1)
        .animation(.smooth(duration: 0.3, extraBounce: 0.5), value: shouldBounce)
    }
}

#Preview {
    HStack {
        VStack {
            ForEach(SetCard.Shapes.allCases) { shape in
                CardView(SetCard(shape: shape, shapeCount: .one, shading: .open, color: .purple))
            }
        }
        VStack {
            ForEach(SetCard.Shapes.allCases) { shape in
                CardView(SetCard(shape: shape, shapeCount: .two, shading: .solid, color: .pink))
            }
        }
        VStack {
            ForEach(SetCard.Shapes.allCases) { shape in
                CardView(SetCard(shape: shape, shapeCount: .three, shading: .striped, color: .blue))
            }
        }
    }
    .padding()
}
