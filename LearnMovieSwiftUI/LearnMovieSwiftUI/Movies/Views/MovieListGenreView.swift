//
//  MovieListGenreView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/22.
//

import SwiftUI

struct MovieListGenreView: View {
    @EnvironmentObject var viewModel: MovieListHomeViewModel
    
    var body: some View {
        List(viewModel.genres) { genre in
            NavigationLink(destination: MovieGenreDetailListView(genre: genre)) {
                Text(genre.name)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct MovieListGenreView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListGenreView()
            .environmentObject(MovieListHomeViewModel())
    }
}
