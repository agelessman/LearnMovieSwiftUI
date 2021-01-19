//
//  MovieTabbarView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/18.
//

import SwiftUI

struct MovieTabbarView: View {
    @State private var selectedItem = Tab.movies
    
    enum Tab {
        case movies, discover, fanClub, myLists
    }
    
    var body: some View {
        TabView(selection: $selectedItem,
                content:  {
                    NavigationView {
                        MovieListHomeView()
                    }
                    .tabItem {
                        MovieTabbarItem(title: "Movies", imageName: "film")
                    }
                    .tag(Tab.movies)
                    NavigationView {
                        MovieDiscoverHomeView()
                    }
                    .tabItem {
                        MovieTabbarItem(title: "Discover", imageName: "square.stack")
                    }
                    .tag(Tab.discover)
                    NavigationView {
                        MovieFanClubHomeView()
                    }
                    .tabItem {
                        MovieTabbarItem(title: "Fan Club", imageName: "star.circle.fill")
                    }
                    .tag(Tab.fanClub)
                    NavigationView {
                        MovieMyListHomeView()
                    }
                    .tabItem {
                        MovieTabbarItem(title: "My Lists", imageName: "heart.circle")
                    }
                    .tag(Tab.myLists)
                })
    }
}

struct MovieTabbarItem: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .imageScale(.large)
            
            Text(title)
        }
    }
}

struct MovieTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MovieTabbarView()
    }
}