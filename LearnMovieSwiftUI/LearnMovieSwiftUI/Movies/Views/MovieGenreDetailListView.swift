//
//  MovieGenreDetailListView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/22.
//

import SwiftUI

struct MovieGenreDetailListView: View {
    let genre: MovieGenre
    
    @StateObject private var viewModel = MovieGenreDetailListViewModel()
    @State private var isSortSheetPresented = false
    
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
        .navigationBarTitle(genre.name, displayMode: .large)
        .navigationBarItems(trailing: (
            MovieGenreSortButton(isSortSheetPresented: $isSortSheetPresented)
        ))
        .actionSheet(isPresented: $isSortSheetPresented) {
            var buttons: [ActionSheet.Button] = []

            for sort in MoviesSort.allCases {
                buttons.append(.default(Text(sort.title()), action: {
                    self.viewModel.sortBy = sort
                    self.viewModel.loadNewData()
                }))
            }
            buttons.append(.cancel())

            return ActionSheet(title: Text("选择排序方式"),
                               message: nil,
                               buttons: buttons)
        }
        .onAppear {
            viewModel.genre = genre
            viewModel.loadData()
        }
    }
}

struct MovieGenreSortButton: View {
    @Binding var isSortSheetPresented: Bool
    
    var body: some View {
        Button(action: {
            isSortSheetPresented.toggle()
        }) {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .imageScale(.large)
                .foregroundColor(.steam_theme)
        }
    }
}

struct MovieGenreDetailListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieGenreDetailListView(genre: MovieGenre(id: 0, name: "test"))
    }
}
