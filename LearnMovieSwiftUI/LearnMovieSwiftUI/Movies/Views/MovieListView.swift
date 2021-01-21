//
//  MovieListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import SwiftUI

struct MovieListView: View {
    let movies: [Movie]
    @Binding var selectedIndex: Int
    @Binding var page: Int
    
    var body: some View {
        VStack(spacing: 0) {
            MovieListMenuSelector(menus: MoviesMenu.allCases,
                                  selectedIndex: $selectedIndex)
            
            List {
                ForEach(movies) { movie in
                    MovieListRow(movie: movie)
                }
                
                /// 加载更多
                if !movies.isEmpty {
                    Rectangle()
                        .foregroundColor(.clear)
//                        .onAppear {
//                            self.page += 1
//                        }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movies: [sampleMovie],
                      selectedIndex: .constant(0),
                      page: .constant(1))
    }
}
