//
//  MovieImage.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/4.
//

import SwiftUI

struct ImageData: Codable, Identifiable {
    var id: String {
        file_path
    }
    let aspect_ratio: Float
    let file_path: String
    let height: Int
    let width: Int
}

struct ImagesResponse: Codable {
    let id: Int
    let profiles: [ImageData]
}
