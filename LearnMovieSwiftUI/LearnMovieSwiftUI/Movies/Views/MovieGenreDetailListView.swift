//
//  MovieGenreDetailListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/22.
//

import SwiftUI

struct MovieGenreDetailListView: View {
    let genre: MovieGenre
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MovieGenreDetailListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieGenreDetailListView(genre: MovieGenre(id: 1, name: "动作"))
    }
}
