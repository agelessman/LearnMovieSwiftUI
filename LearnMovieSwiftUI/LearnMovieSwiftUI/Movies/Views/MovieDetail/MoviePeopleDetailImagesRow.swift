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
    @Binding var selectedPoster: ImageData?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("相册")
                .titleStyle()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(images) { image in
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w185/\(image.file_path)"))
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
                    }
                }
            }
        }
        .padding(.vertical, 5)
//        .padding(.horizontal, 10)
    }
}
