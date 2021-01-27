//
//  MoiveListGridView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/26.
//

import SwiftUI

struct MoiveListGridView: View {
    @StateObject var viewModel = MovieListGridViewModel()
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(0..<viewModel.movies.count, id: \.self) { index in
                    if !viewModel.movies[index].1.isEmpty {
                        MovieListGridRowView(data: viewModel.movies[index])
                    }
                }
            }
            
            LazyVStack(spacing: 1) {
                ForEach(viewModel.genres) { genre in
                    NavigationLink(destination:
                                    MovieGenreDetailListView(genre: genre)) {
                        ZStack {
                            VStack {
                                Spacer()
                                Divider()
                            }
                            
                            HStack {
                                Text(genre.name)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

struct MoiveListGridView_Previews: PreviewProvider {
    static var previews: some View {
        MoiveListGridView()
    }
}
