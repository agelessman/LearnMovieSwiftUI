//
//  MovieReview.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/28.
//

import SwiftUI

struct MovieReview: Codable, Identifiable {
    let id: String
    let author: String
    let content: String
}
