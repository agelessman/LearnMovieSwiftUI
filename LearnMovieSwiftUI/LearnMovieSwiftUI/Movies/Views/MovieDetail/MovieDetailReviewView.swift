//
//  MovieDetailReviewView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/1.
//

import SwiftUI

struct MovieDetailReviewView: View {
    let movieId: Int
    let reviewCount: Int
        
    var body: some View {
        NavigationLink(destination: MovieReviewsView(movieId: movieId)) {
            HStack {
                Text("\(reviewCount)条评论")
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

struct MovieDetailReviewView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailReviewView(movieId: 0, reviewCount: 0)
    }
}
