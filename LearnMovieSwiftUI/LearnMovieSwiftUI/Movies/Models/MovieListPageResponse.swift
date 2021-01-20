//
//  MovieListPageResponse.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import Foundation

struct MovieListPageResponse<T: Codable>: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [T]
}
