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
    
    // Card properties
    var shapeCount: Int { card.shapeCount.rawValue }
    var baseColor: Color {
        switch card.color {
        case .purple:
            .purple
        case .pink:
            .pink.darkened(strength: 0.03)
        case .blue:
            .blue
        }
    }
    
    @ViewBuilder
    private var cardShape: some View {
        switch card.shape {
        case .diamond:
            applyShadingAndColor(Diamond())
        case .squiggle:
            applyShadingAndColor(Squiggle())
        case .oval:
            applyShadingAndColor(Oval())
        }
    }
    
    @ViewBuilder
    private func applyShadingAndColor<T: Shape>(_ shape: T) -> some View {
        switch card.shading {
        case .solid:
            shape.fill(baseColor)
        case .striped:
            shape.fill(baseColor).opacity(0.3)
        case .open:
            shape.stroke(baseColor, lineWidth: 2.5)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(gradient: baseColor.lighter.brightnessGradient,
                                       startPoint: .topTrailing,
                                       endPoint: .bottomLeading), lineWidth: 4)
                .aspectRatio(5/7, contentMode: .fit)
                .overlay(alignment: .center) {
                    VStack {
                        ForEach(0..<shapeCount, id: \.self) { _ in
                            cardShape
                                .aspectRatio(5/3, contentMode: .fit)
                        }
                    }
                    .padding()
                }
        }
    }
}

#Preview {
    HStack {
        VStack {
            ForEach(SetCard.Shapes.allCases) { shape in
                CardView(card: SetCard(shape: shape, shapeCount: .one, shading: .solid, color: .purple))
            }
            .padding()
        }
        VStack {
            ForEach(SetCard.Shapes.allCases) { shape in
                CardView(card: SetCard(shape: shape, shapeCount: .two, shading: .solid, color: .pink))
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

extension Color {
    private func getHSB(_ col: Color) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        let uiColor = UIColor(col)
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue, saturation, brightness, alpha)
    }
    
    var lighter: Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 + 0.4, opacity: baseHSB.3)
    }
    
    func lightened(strength: Double) -> Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 + strength, opacity: baseHSB.3)
    }
    
    var darker: Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 - 0.4, opacity: baseHSB.3)
    }
    
    func darkened(strength: Double) -> Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0, saturation: baseHSB.1, brightness: baseHSB.2 - strength, opacity: baseHSB.3)
    }
}
