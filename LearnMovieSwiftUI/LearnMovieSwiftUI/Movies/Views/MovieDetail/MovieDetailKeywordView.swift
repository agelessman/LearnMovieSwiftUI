//
//  MovieDetailKeywordView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/1.
//

import SwiftUI

struct MovieDetailKeywordView: View {
    let keywords: [MovieKeyword]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("关键词")
                .titleStyle()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<keywords.count, id: \.self) { index in
                        NavigationLink(destination: MovieKeywordListView(keyword: keywords[index])) {
                            MovieDetailKeywordRoundedBadge(keyword: keywords[index])
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}

struct MovieDetailKeywordRoundedBadge: View {
    let keyword: MovieKeyword
    
    var body: some View {
        HStack(spacing: 5) {
            Text(keyword.name)
                .foregroundColor(.primary)
                .font(.footnote)
                
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 5, height: 10)
                .foregroundColor(.primary)
            
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(Color.steam_systemBackground)
        .clipShape(Capsule())
    }
}

struct MovieDetailKeywordView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailKeywordView(keywords: [])
    }
}
