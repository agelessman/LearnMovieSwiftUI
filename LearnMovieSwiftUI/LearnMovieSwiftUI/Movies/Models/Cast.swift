//
//  Cast.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/2.
//

import Foundation
import SwiftUI

struct People: Codable, Identifiable {
    let id: Int
    let name: String
    var character: String?
    var department: String?
    let profile_path: String?
        
    let known_for_department: String?
    var known_for: [KnownFor]?
    let also_known_as: [String]?
    
    let birthDay: String?
    let deathDay: String?
    let place_of_birth: String?
    
    let biography: String?
    let popularity: Double?
    
    struct KnownFor: Codable, Identifiable {
        let id: Int
        let original_title: String?
        let poster_path: String?
    }
}

extension People {
    var knownForText: String? {
        guard let knownFor = known_for else {
            return nil
        }
        let names = knownFor.filter{ $0.original_title != nil}.map{ $0.original_title! }
        return names.joined(separator: ", ")
    }
}

struct CastResponse: Codable {
    let id: Int
    let cast: [People]
    let crew: [People]
}

