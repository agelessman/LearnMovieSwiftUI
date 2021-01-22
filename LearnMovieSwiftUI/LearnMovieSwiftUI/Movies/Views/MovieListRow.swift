//
//  MovieListRow.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import SwiftUI
import SDWebImageSwiftUI

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日"
    return formatter
}()

struct MovieListRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"))
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color("steam_purple").opacity(0.5))
                        .frame(width: 100, height: 150)
                }
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 100, height: 150)
                .cornerRadius(4)
            
            VStack(alignment: .leading) {
                Text(movie.userTitle)
                    .titleStyle()
                    .foregroundColor(.steam_theme)
                    .lineLimit(2)
                
                HStack(spacing: 10) {
                    MoviePopularityBadge(pct: CGFloat(movie.vote_average) / 10,
                                         textColor: .primary)
                    
                    Text("上映日期 \(formatter.string(from: movie.releaseDate ?? Date()))")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .lineLimit(1)
                }
                
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
                    .truncationMode(.tail)
                
                Spacer()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .overlay(
            VStack(spacing: 0) {
                Spacer()
                Divider()
                    .padding(.horizontal, 12)
            }
        )
    }
}

struct MovieListRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieListRow(movie: sampleMovie)
    }
}
