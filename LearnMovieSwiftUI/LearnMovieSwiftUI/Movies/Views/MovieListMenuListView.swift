//
//  MovieListMenuListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/27.
//

import SwiftUI

struct MovieListMenuListView: View {
    let menu: MoviesMenu
    
    @StateObject private var viewModel = MovieListMenuListViewModel()
    
    var body: some View {
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
                        self.viewModel.loadMoreData()
                    }
                }
            }
        }
        .navigationBarTitle(menu.title(), displayMode: .large)
        .onAppear {
            viewModel.menu = menu
            viewModel.loadData()
        }
    }
}
