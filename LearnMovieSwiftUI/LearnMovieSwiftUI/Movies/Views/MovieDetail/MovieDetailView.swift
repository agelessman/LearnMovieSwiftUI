//
//  MovieDetailView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @StateObject var viewModel = MovieDetailViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                /// 头部
                if viewModel.movie != nil {
                    MovieDetailHeaderView(movie: viewModel.movie!)
                }
                
                /// 评论
                if viewModel.reviewCount > 0 {
                    MovieDetailReviewView(movieId: movieId, reviewCount: viewModel.reviewCount)
                }
                
                /// 简介
                if viewModel.movie?.overview != nil {
                    MovieDetailOverviewView(overview: viewModel.movie!.overview)
                }
                
                /// 关键词
                if viewModel.movie?.keywords?.keywords?.isEmpty == false {
                    MovieDetailKeywordView(keywords: viewModel.movie!.keywords!.keywords!)
                }
                
                /// 演员
                if !viewModel.characters.isEmpty {
                    MovieDetailCrossLinePeopleRowView(title: "演员", peoples: viewModel.characters)
                }
            }
        }
        .navigationBarTitle("电影详情", displayMode: .automatic)
        .onAppear {
            viewModel.loadDetail(movieId: movieId)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieId: 0)
    }
}
