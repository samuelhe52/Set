//
//  ShakeEffect.swift
//  Set
//
//  Created by Samuel He on 2024/8/13.
//

import SwiftUI

struct ShakeEffect: ViewModifier {
    var singleShakeDuration: TimeInterval = 0.06
    
    @State var shaking: Bool
    
    func body(content: Content) -> some View {
        return content
            .rotationEffect(.degrees(shaking ? 7 : 0))
            .animation(
                shaking ? .easeInOut(duration: 0.06).repeatForever() : .default,
                value: shaking
            )
    }
}

extension View {
    func shakeEffect(singleShakeDuration: TimeInterval = 0.06,
                     shaking: Bool
    ) -> some View {
        modifier(ShakeEffect(singleShakeDuration: singleShakeDuration,
                             shaking: shaking))
    }
}
