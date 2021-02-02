//
//  MovieDetailCrossLinePeopleRowView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/2.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailCrossLinePeopleRowView: View {
    let title: String
    let peoples: [People]
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .titleStyle()
                
                Spacer()
                
                NavigationLink(destination: PeoplesListView(title: title, peoples: peoples)) {
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(peoples) { people in
                        NavigationLink(destination: MoviePeopleDetailView(people: people)) {
                            PeopleRowItem(people: people)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}

struct PeopleRowItem: View {
    let people: People
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w185/\(people.profile_path ?? "")"))
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
            
            Text(people.name)
                .font(.footnote)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(people.character ?? people.department ?? "")
                .font(.footnote)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(width: 100)
    }
}

struct PeoplesListView: View {
    let title: String
    let peoples: [People]
    
    var body: some View {
        List {
            ForEach(peoples) { people in
                NavigationLink(destination: MoviePeopleDetailView(people: people)) {
                    HStack {
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w185/\(people.profile_path ?? "")"))
                            .resizable()
                            .placeholder {
                                Rectangle()
                                    .foregroundColor(Color("steam_purple").opacity(0.5))
                                    .frame(width: 60, height: 90)
                                    .overlay(
                                        Text("暂无图片")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    )
                            }
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(width: 60, height: 90)
                            .cornerRadius(4)
                        
                        VStack(alignment: .leading) {
                            Text(people.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(people.character ?? people.department ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}

struct MovieDetailCrossLinePeopleRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailCrossLinePeopleRowView(title: "", peoples: [])
    }
}
