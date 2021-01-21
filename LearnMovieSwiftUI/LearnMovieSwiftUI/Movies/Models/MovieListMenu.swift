//
//  MovieListMenu.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/19.
//

import Foundation

enum MoviesMenu: Int, CaseIterable {
    case nowPlaying, upcoming, trending, popular, topRated, genres
    
    func title() -> String {
        switch self {
        case .popular: return "流行"
        case .topRated: return "高分"
        case .upcoming: return "即将上映"
        case .nowPlaying: return "正在热映"
        case .trending: return "热门"
        case .genres: return "分类"
        }
    }
    
    func endpoint() -> APIService.Endpoint {
        switch self {
        case .popular: return APIService.Endpoint.popular
        case .topRated: return APIService.Endpoint.topRated
        case .upcoming: return APIService.Endpoint.upcoming
        case .nowPlaying: return APIService.Endpoint.nowPlaying
        case .trending: return APIService.Endpoint.trending
        case .genres: return APIService.Endpoint.genres
        }
    }
}
