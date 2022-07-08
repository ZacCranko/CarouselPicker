//
//  SwiftUIView.swift
//  
//
//  Created by Zac Cranko on 4/7/2022.
//

import SwiftUI

struct CarouselPickerLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let sideLength = rect.height * 2/sqrt(3)
            let firstVertex = CGPoint(x: rect.midX - sideLength / 2, y: rect.minY)
            let lastVertex = CGPoint(x: rect.midX + sideLength / 2, y: rect.minY)

            path.move(to: firstVertex)
            path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
            path.addLine(to: lastVertex)
            path.addLine(to: firstVertex)
        }
    }
}

struct CarouselPickerLineGraphic: View {
    var body: some View {
        CarouselPickerLineShape()
            .fill()
            .foregroundColor(Color(.separator))
            .frame(height: 10, alignment: .top)
            .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
                Divider()
                    .frame(maxWidth: .infinity)
            }
    }
}

struct CarouselPickerLineGraphic_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CarouselPickerLineGraphic()
        }
        .previewLayout(.fixed(width: 300, height: 200))
    }
}
