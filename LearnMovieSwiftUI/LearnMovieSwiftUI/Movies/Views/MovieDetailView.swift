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
            if viewModel.movie != nil {
                MovieDetailHeaderView(movie: viewModel.movie!)
            }
            if viewModel.reviewCount > 0 {
                NavigationLink(destination: MovieReviewsView(movieId: movieId)) {
                    HStack {
                        Text("\(viewModel.reviewCount)条评论")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 40)
                    .padding(.horizontal, 10)
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
