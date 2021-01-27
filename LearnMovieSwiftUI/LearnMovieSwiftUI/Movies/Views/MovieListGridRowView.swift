//
//  MovieListGridRowView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListGridRowView: View {
    let data: (MoviesMenu, [Movie])
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(data.0.title())
                    .titleFont(size: 20)
                    .foregroundColor(.steam_theme)
                    .padding(.vertical, 10)
                
                Spacer()
                
                NavigationLink(destination: MovieListMenuListView(menu: data.0)) {
                    HStack(spacing: 0) {
                        Text("查看更多")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(data.1) { movie in
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "missing")"))
                            .resizable()
                            .placeholder {
                                Rectangle()
                                    .foregroundColor(Color("steam_purple").opacity(0.5))
                                    .frame(width: 100, height: 150)
                                    .overlay(
                                        Text("暂无图片")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    )
                            }
                            
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .cornerRadius(4)
                            .shadow(radius: 2)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
}
