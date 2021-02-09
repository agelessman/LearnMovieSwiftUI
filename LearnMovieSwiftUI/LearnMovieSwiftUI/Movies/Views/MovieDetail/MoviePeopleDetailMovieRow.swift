//
//  MoviePeopleDetailMovieRow.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/9.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoviePeopleDetailMovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w185/\(movie.poster_path ?? "")"))
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color("steam_purple").opacity(0.5))
                        .frame(width: 53, height: 80)
                        .overlay(
                            Text("暂无图片")
                                .foregroundColor(.white)
                                .font(.caption)
                        )
                }
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 53, height: 80)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(movie.department ?? movie.character ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
