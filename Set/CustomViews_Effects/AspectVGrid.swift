//
//  AspectVGrid.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import SwiftUI

struct AspectVGrid<
    Items: RandomAccessCollection,
    ItemView: View
>: View where Items.Element: Identifiable {
    var items: Items
    var itemCount: Int
    var aspectRatio: CGFloat = 1
    var minWidth: CGFloat
    var allRowsFilled: Bool = false
    @ViewBuilder var contentBuilder: (Items.Element) -> ItemView
    
    /// This initializer allows user to provide a custom `itemCount`
    /// for a more customized layout calculation.
    init(items: Items,
         itemCount: Int,
         aspectRatio: CGFloat = 1,
         minWidth: CGFloat,
         allRowsFilled: Bool = false,
         @ViewBuilder contentBuilder: @escaping (Items.Element) -> ItemView) {
        self.items = items
        self.itemCount = itemCount
        self.aspectRatio = aspectRatio
        self.minWidth = minWidth
        self.allRowsFilled = allRowsFilled
        self.contentBuilder = contentBuilder
    }
    
    init(items: Items,
         aspectRatio: CGFloat = 1,
         minWidth: CGFloat,
         allRowsFilled: Bool = false,
         @ViewBuilder contentBuilder: @escaping (Items.Element) -> ItemView) {
        self.items = items
        self.itemCount = items.count
        self.aspectRatio = aspectRatio
        self.minWidth = minWidth
        self.allRowsFilled = allRowsFilled
        self.contentBuilder = contentBuilder
    }

    
    var body: some View {
        GeometryReader { geometry in
            let (itemWidth, scrolling) = properWidth(
                itemCount: itemCount,
                size: geometry.size,
                aspectRatio: aspectRatio,
                minWidth: minWidth,
                allRowsFilled: allRowsFilled
            )
            
            let base = LazyVGrid(columns: [GridItem(.adaptive(minimum: itemWidth), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    contentBuilder(item)
                        .aspectRatio(aspectRatio, contentMode: .fill)
                }
            }
            
            if scrolling {
                ScrollView(showsIndicators: false) { base }
            } else { base }
        }
    }
    
    /// - Returns: The first element of the tuple is the preferred width;
    /// The second, a bool, indicates if the current layout requires scrolling.
    private func properWidth(
        itemCount: Int,
        size: CGSize,
        aspectRatio: CGFloat,
        minWidth: CGFloat = 0,
        allRowsFilled: Bool = false
    ) -> (CGFloat, Bool) {
        guard itemCount > 0 else { return (minWidth, false) }

        let totalWidth = size.width
        let visibleHeight = size.height
        let maxColumns = max(Int((totalWidth / minWidth).rounded(.down)), 1)
        
        for columnCount in 1...maxColumns {
            let rowCount = (CGFloat(itemCount) / CGFloat(columnCount)).rounded(.up)
            let itemWidth = totalWidth / CGFloat(columnCount)
            let itemHeight = itemWidth / aspectRatio
            
            let scrolling = rowCount * itemHeight > visibleHeight
            if !scrolling && (!allRowsFilled || itemCount % columnCount == 0) {
                // A width that satisfy the minWidth and not scrolling is found
                return (itemWidth, false)
            }
        }
        
        // Since the for loop didn't yield any result, we can confirm that
        // we should return the minWidth and revert to scrolling since
        // minWidth has a higher priority.
        return (minWidth, true)
    }
}

