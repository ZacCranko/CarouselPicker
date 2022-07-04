//
//  SwiftUIView.swift
//  
//
//  Created by Zac Cranko on 4/7/2022.
//

import SwiftUI

struct MaxWidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static let defaultValue: CGFloat = .zero
    
    static func reduce(value current: inout Value,
                       nextValue next: () -> Value) {
        current = max(current, next())
    }
}

struct MaxWidthModifier: ViewModifier {
    var alignment: Alignment = .center
    @Binding var width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .fixedSize()
            .background(GeometryReader { geometry in
                  Color.clear.preference(
                      key: MaxWidthPreferenceKey.self,
                      value: geometry.size.width
                  )
              })
            .frame(minWidth: width)
    }
}
