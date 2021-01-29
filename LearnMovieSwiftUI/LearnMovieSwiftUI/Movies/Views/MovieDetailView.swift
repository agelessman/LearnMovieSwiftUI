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
            /// 头部
            if viewModel.movie != nil {
                MovieDetailHeaderView(movie: viewModel.movie!)
            }
            
            /// 评论
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
            
            /// 简介
            if viewModel.movie?.overview != nil {
                VStack(alignment: .leading, spacing: 10) {
                    Text("简介")
                        .foregroundColor(.primary)
                    
                    MovieDetailOverviewText(viewModel.movie!.overview)
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationBarTitle("电影详情", displayMode: .automatic)
        .onAppear {
            viewModel.loadDetail(movieId: movieId)
        }
    }
}

struct MovieDetailOverviewText: View {

    /* Indicates whether the user want to see all the text or not. */
    @State private var expanded: Bool = false

    /* Indicates whether the text has been truncated in its display. */
    @State private var truncated: Bool = false

    private var text: String

    init(_ text: String) {
        self.text = text
    }

    private func determineTruncation(_ geometry: GeometryProxy) {
        
        // Calculate the bounding box we'd need to render the
        // text given the width from the GeometryReader.
        let total = self.text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )

        if total.size.height > geometry.size.height {
            self.truncated = true
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(self.text)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineLimit(self.expanded ? nil : 3)
                .fixedSize(horizontal: false, vertical: true)
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        self.determineTruncation(geometry)
                    }
                })

            if self.truncated {
                self.toggleButton
            }
        }
    }

    var toggleButton: some View {
        Button(action: {
            withAnimation {
                self.expanded.toggle()
                self.truncated.toggle()
            }
        }) {
            Text("展开")
                .font(.caption)
        }
    }

}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieId: 0)
    }
}
