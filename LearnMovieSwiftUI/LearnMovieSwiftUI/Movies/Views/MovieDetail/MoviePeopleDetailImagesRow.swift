//
//  MoviePeopleDetailImagesRow.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/7.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoviePeopleDetailImagesRow: View {
    let images: [ImageData]
    
    @State private var isPresented = false
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("相册")
                .titleStyle()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<images.count, id: \.self) { index in
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w185/\(images[index].file_path)"))
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
                            .scaledToFill()
                            .frame(width: 100, height: 150)
                            .cornerRadius(10)
                            .onTapGesture {
                                self.selectedIndex = index
                                self.isPresented.toggle()
                            }
                    }
                }
            }
        }
        .padding(.vertical, 5)
        .fullScreenCover(isPresented: $isPresented) {
            MovieImageBrowser(imageURLs: images.map { "https://image.tmdb.org/t/p/w500/\($0.file_path)" },
                              index: $selectedIndex)
        }
    }
}
