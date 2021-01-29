//
//  MovieReviewsView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/28.
//

import SwiftUI

struct MovieReviewsView: View {
    let movieId: Int
    
    @StateObject var viewModel = MovieReviewsViewModel()
    
    var body: some View {
        List {
            
            ForEach(viewModel.reviews) { review in
                VStack(alignment: .leading, spacing: 10) {
                    Text(review.author)
                        .font(.headline)
                    
                    Text(review.content)
                        .font(.body)
                }
            }
            
            /// 加载更多
            if viewModel.showLoadingMore {
                HStack {
                    Spacer()
                    ProgressView("正在加载数据...")
                    Spacer()
                }
                .onAppear {
                    viewModel.loadData()
                }
            }
        }
        .navigationTitle("点评详情")
        .onAppear {
            viewModel.movieId = movieId
            viewModel.loadData()
        }
    }
}

struct MovieReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieReviewsView(movieId: 0)
    }
}
