//
//  AppUserDefaults.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import Foundation

public struct AppUserDefaults {
    @UserDefault("user_region", defaultValue: Locale.current.regionCode ?? "CN")
    public static var region: String
        
    @UserDefault("original_title", defaultValue: false)
    public static var alwaysOriginalTitle: Bool
}
