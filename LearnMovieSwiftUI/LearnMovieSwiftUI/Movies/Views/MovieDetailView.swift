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
