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
    var aspectRatio: CGFloat = 1
    var minWidth: CGFloat
    var allRowsFilled: Bool = false
    @ViewBuilder var contentBuilder: (Items.Element) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            let (columnCount, scrolling) = properColumnCount(
                itemCount: items.count,
                size: geometry.size,
                aspectRatio: aspectRatio,
                minWidth: minWidth,
                allRowsFilled: allRowsFilled
            )
            
            let itemWidth = geometry.size.width / CGFloat(columnCount)
            
            let base = LazyVGrid(columns: [GridItem(.adaptive(minimum: itemWidth), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    contentBuilder(item)
                        .aspectRatio(aspectRatio, contentMode: .fill)
                }
            }
            
            return Group {
                if scrolling {
                    if #available(iOS 16.0, *) {
                        ScrollView {
                            base
                        }.scrollIndicators(.never)
                    } else {
                        ScrollView(showsIndicators: false) {
                            base
                        }
                    }
                } else {
                    base
                }
            }
            
        }
    }
    
    /// - Returns: The first element of the tuple is the preferred column count;
    /// The second, a bool, indicates if the curretn layout requires scrolling.
    private func properColumnCount(
        itemCount: Int,
        size: CGSize,
        aspectRatio: CGFloat,
        minWidth: CGFloat = 0,
        allRowsFilled: Bool = false
    ) -> (Int, Bool) {
        let totalWidth = size.width
        let visibleHeight = size.height
        
        guard itemCount > 0 else { return (1, false) }
        var columnCount = 0
        
        var scrolling: Bool = false
        
        repeat {
            let rowCount = (CGFloat(itemCount) / CGFloat(columnCount)).rounded(.up)
            let itemWidth = totalWidth / CGFloat(columnCount)
            let itemHeight = itemWidth / aspectRatio
            scrolling = rowCount * itemHeight > visibleHeight
            
            if !scrolling && (!allRowsFilled || itemCount % columnCount == 0) {
                break
            }
            columnCount += 1
        } while columnCount < Int((totalWidth / minWidth).rounded(.down))
                
        return (columnCount, scrolling)
    }
}

