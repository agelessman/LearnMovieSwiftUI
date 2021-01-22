//
//  MovieGenre.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/22.
//

import Foundation

struct MovieGenre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct MovieGenresResponse: Codable {
    let genres: [MovieGenre]
}
