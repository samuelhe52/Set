//
//  shakeEffect.swift
//  Set
//
//  Created by Samuel He on 2024/8/13.
//

import SwiftUI

struct shakeEffect: ViewModifier {
    var singleShakeDuration: TimeInterval = 0.06
    
    @State var shouldShake: Bool
    
    func body(content: Content) -> some View {
        return content
            .rotationEffect(.degrees(shouldShake ? 7 : 0))
            .animation(
                shouldShake ?
                    .easeInOut(duration: singleShakeDuration)
                    .repeatForever():
                    .default,
                value: shouldShake)
    }
}

extension View {
    func shakeEffect(singleShakeDuration: TimeInterval = 0.06,
                    shouldShake: Bool
    ) -> some View {
        modifier(shakeEffect(singleShakeDuration: singleShakeDuration,
                                  shouldShake: shouldShake))
    }
}
