//
//  MovieListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import SwiftUI

struct MovieListView: View {
    let movies: [Movie]
    @Binding var selectedMenu: MoviesMenu
    
    var body: some View {
        VStack(spacing: 0) {
            MovieListMenuSelector(menus: MoviesMenu.allCases,
                                  selectedMenu: $selectedMenu)
            List(movies) { movie in
                Text(movie.title)
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movies: [sampleMovie],
                      selectedMenu: .constant(.nowPlaying))
    }
}
