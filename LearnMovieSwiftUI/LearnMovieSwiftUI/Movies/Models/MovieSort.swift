//
//  MovieSort.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/22.
//

enum MoviesSort: CaseIterable {
    case byReleaseDate, byAddedDate, byScore, byPopularity
    
    func title() -> String {
        switch self {
        case .byReleaseDate:
            return "上映日期"
        case .byAddedDate:
            return "添加日期"
        case .byScore:
            return "评分"
        case .byPopularity:
            return "人气排名"
        }
    }
    
    func sortByAPI() -> String {
        switch self {
        case .byReleaseDate:
            return "release_date.desc"
        case .byAddedDate:
            return "primary_release_date.desc"
        case .byScore:
            return "vote_average.desc"
        case .byPopularity:
            return "popularity.desc"
        }
    }
}
