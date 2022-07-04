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
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            let sideLength = rect.height * 2/sqrt(3)
            
            let firstVertex = CGPoint(x: rect.midX - sideLength / 2, y: rect.minY)
            let lastVertex = CGPoint(x: rect.midX + sideLength / 2, y: rect.minY)
            
            path.move(to: firstVertex)
            path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
            path.addLine(to: lastVertex)
            path.addLine(to: firstVertex)
            
            path.closeSubpath()
        }
    }
}

struct CarouselPickerLineGraphic: View {
    var body: some View {
        CarouselPickerLineShape()
            .stroke(style: StrokeStyle(lineWidth: 0.5, lineCap: .square))
            .background {
                CarouselPickerLineShape().fill()
            }
            .compositingGroup()
    }
}

struct CarouselPickerLineGraphic_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPickerLineGraphic()
            .frame(height: 20)
    }
}
