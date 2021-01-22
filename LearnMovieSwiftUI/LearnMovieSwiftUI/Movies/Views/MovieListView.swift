//
//  MovieListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import SwiftUI

struct MovieListView: View {
    @EnvironmentObject var viewModel: MovieListHomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            MovieListMenuSelector(menus: MoviesMenu.allCases,
                                  selectedIndex: $viewModel.selectedIndex)
            
            if MoviesMenu.allCases[viewModel.selectedIndex] == MoviesMenu.genres {
                MovieListGenreView()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.movies) { movie in
                            MovieListRow(movie: movie)
                        }
                        
                        /// 加载更多
                        if !viewModel.movies.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView("正在加载数据...")
                                Spacer()
                            }
                            .onAppear {
                                viewModel.loadMoreData()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
            .environmentObject(MovieListHomeViewModel())
    }
}
