//
//  FluidGradientOverlay.swift
//  Set
//
//  Created by Samuel He on 2024/8/13.
//

import SwiftUI
import FluidGradient

/// Either `color` or `colors` must be nil (i.e. One of them must be given a value when initiating).
struct FluidGradientOverlay<S: Shape>: ViewModifier {
    var color: Color?
    var colors: [Color]?
    var clipShape: S
    var speed: Double = 0.3
    var isVisible: Bool
    
    private func fluidGradient(color: Color) -> some View {
        let colors: [Color] = [color.lightened(strength: 1),
                               color,
                               color.lightened(strength: 0.5)]
        return FluidGradient(blobs: colors, speed: speed)
    }
    
    private func fluidGradient(colors: [Color]) -> some View {
        return FluidGradient(blobs: colors, speed: speed)
    }
    
    func body(content: Content) -> some View {
        content.overlay {
            if isVisible {
                if let colors = colors {
                    fluidGradient(colors: colors)
                        .clipShape(clipShape)
                        .blur(radius: 5)
                } else if let color = color {
                    fluidGradient(color: color)
                        .clipShape(clipShape)
                        .blur(radius: 5)
                }
            }
        }
    }
}

extension View {
    func fluidGradientOverlay(color: Color,
                              clipShape: some Shape,
                              speed: Double = 0.3,
                              isVisible: Bool = true) -> some View {
        modifier(FluidGradientOverlay(color: color,
                                      clipShape: clipShape,
                                      speed: speed,
                                      isVisible: isVisible))
    }
    
    func fluidGradientOverlay(colors: [Color],
                              clipShape: some Shape,
                              speed: Double = 0.3,
                              isVisible: Bool = true) -> some View {
        modifier(FluidGradientOverlay(colors: colors,
                                      clipShape: clipShape,
                                      speed: speed,
                                      isVisible: isVisible))
    }
}

#Preview {
    VStack{
        Circle()
            .fluidGradientOverlay(color: .blue,
                                  clipShape: Circle())
        RoundedRectangle(cornerRadius: 20)
            .fluidGradientOverlay(color: .purple,
                                  clipShape: RoundedRectangle(cornerRadius: 20))
    }
    .padding()
}

