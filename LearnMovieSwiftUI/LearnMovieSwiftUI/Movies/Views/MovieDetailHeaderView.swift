//
//  MovieDetailHeaderView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailHeaderView: View {
    let movie: Movie
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.backdrop_path ?? "")"))
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color("steam_purple").opacity(0.5))
                        .frame(height: 200)
                }
                .blur(radius: 50, opaque: true)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(height: 200)
                .clipped()
            
            HStack {
                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"))
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .foregroundColor(Color("steam_purple").opacity(0.5))
                            .frame(width: 100, height: 150)
                    }
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width: 100, height: 150)
                    .cornerRadius(4)
                
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text(movie.original_title)
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.subheadline)
                    
                    HStack {
                        MoviePopularityBadge(pct: CGFloat(movie.vote_average) / 10, textColor: .primary)
                        
                        Text("\(movie.vote_count)人评")
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                
                    
                    HStack {
                        BorderedButton(text: "想看", systemImageName: "heart", color: .pink, isOn: false) {
                            
                        }
                        BorderedButton(text: "看过", systemImageName: "eye", color: .green, isOn: false) {
                            
                        }
                    }
                }
                
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

public struct BorderedButton : View {
    public let text: String
    public let systemImageName: String
    public let color: Color
    public let isOn: Bool
    public let action: () -> Void
    
    public init(text: String, systemImageName: String, color: Color, isOn: Bool, action: @escaping () -> Void) {
        self.text = text
        self.systemImageName = systemImageName
        self.color = color
        self.isOn = isOn
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            self.action()
        }, label: {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: systemImageName).foregroundColor(isOn ? .white : color)
                Text(text).foregroundColor(isOn ? .white : color)
            }
            })
            .buttonStyle(BorderlessButtonStyle())
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: isOn ? 0 : 2)
                .background(isOn ? color : .clear)
                .cornerRadius(8))
    }
}
