//
//  MovieListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import SwiftUI

struct MovieListView: View {
    var movies: [Movie]
    var selectedMenu: Binding<MoviesMenu>
    
    var body: some View {
        Text("dd")
        HStack {
            ForEach(MoviesMenu.allCases, id: \.self) { menu in
                Text(menu.title())
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movies: [sampleMovie],
                      selectedMenu: .constant(.nowPlaying))
    }
}
