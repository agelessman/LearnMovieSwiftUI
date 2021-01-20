//
//  MovieListRow.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"))
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color("steam_purple").opacity(0.5))
                        .frame(width: 100, height: 150)
                }
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 100, height: 150)
        }
    }
}

struct MovieListRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieListRow(movie: sampleMovie)
    }
}
