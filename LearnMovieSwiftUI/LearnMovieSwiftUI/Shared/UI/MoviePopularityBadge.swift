//
//  MoviePopularityBadge.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/21.
//

import SwiftUI

struct MoviePopularityBadge: View {
    let pct: CGFloat
    let textColor: Color
    
    var body: some View {
        Circle()
            .fill(Color.steam_white)
            .frame(width: 40, height: 40)
            .modifier(MoviePopularityBadgeAnimatableModifier(pct: pct,
                                                             textColor: textColor))
    }
}

struct MoviePopularityBadgeAnimatableModifier: AnimatableModifier {
    var pct: CGFloat
    var textColor: Color
    
    var arcShapeColor: Color {
        switch pct {
        case 0:
            return Color.gray.opacity(0.5)
        case 0.1..<0.4:
            return .red
        case 0.4..<0.6:
            return .orange
        case 0.6..<0.75:
            return .yellow
        default:
            return .green
        }
    }
    
    var animatableData: CGFloat {
        get {
            pct
        }
        set {
            pct = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(ArcShape(pct: pct).foregroundColor(arcShapeColor))
            .overlay(
                Text("\(pct * 100, specifier: "%.0f")%")
                    .foregroundColor(textColor)
                    .font(.system(size: 10))
                    .bold()
            )
    }
    
    struct ArcShape: Shape {
       var pct: CGFloat
       
       func path(in rect: CGRect) -> Path {
           var path = Path()
           
           path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0),
                       radius: rect.height / 2.0,
                       startAngle: .degrees(-90),
                       endAngle: .degrees(pct == 0 ? 270 : Double(pct) * 360 - 90),
                       clockwise: false)
           return path.strokedPath(.init(lineWidth: 3, dash: [1], dashPhase: 0))
       }
   }
}

struct MoviePopularityBadge_Previews: PreviewProvider {
    static var previews: some View {
        MoviePopularityBadge(pct: 0.5, textColor: .green)
    }
}
