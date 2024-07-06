//
//  SetGameCard.swift
//  Set
//
//  Created by Samuel He on 2024/7/6.
//

import Foundation
import SwiftUI

struct SetGameCard: Identifiable, CustomStringConvertible {
    // card properties declaration
    var shape: SetCardShapes
    var number: SetCardShapeNumbers
    var shading: SetCardShadings
    
    var selected: Bool = false
    
    var id: UUID = UUID()
    var description: String { "A card with \(number.rawValue) \(shading.description) \(shape.description)(s)" }
    
    // MARK: - Enumerations for card properties
    
    enum SetCardShapes: CustomStringConvertible, CaseIterable {
        case diamond, squiggle, oval
        
        var description: String {
            switch self {
            case .diamond:
                return "diamond"
            case .squiggle:
                return "squiggle"
            case .oval:
                return "oval"
            }
        }
    }

    enum SetCardShapeNumbers: Int, CaseIterable {
        case one = 1, two, three
    }

    enum SetCardShadings: CustomStringConvertible, CaseIterable {
        case solid, striped, open
        
        var description: String {
            switch self {
            case .solid:
                return "solid"
            case .striped:
                return "striped"
            case .open:
                return "open"
            }
        }
    }
}
