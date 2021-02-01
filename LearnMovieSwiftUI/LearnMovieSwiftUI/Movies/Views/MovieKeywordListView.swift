//
//  MovieKeywordListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/1.
//

import SwiftUI

struct MovieKeywordListView: View {
    let keyword: MovieKeyword
    
    @StateObject private var viewModel = MovieKeywordListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.movies) { movie in
                    MovieListRow(movie: movie)
                }

                /// 加载更多
                if viewModel.showLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView("正在加载数据...")
                        Spacer()
                    }
                    .onAppear {
                        self.viewModel.loadData()
                    }
                }
            }
        }
        .navigationBarTitle(keyword.name, displayMode: .large)
        .onAppear {
            viewModel.keyword = keyword
            viewModel.loadData()
        }
    }
}
