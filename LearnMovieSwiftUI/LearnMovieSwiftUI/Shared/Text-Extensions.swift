//
//  Text-Extensions.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/7.
//

import SwiftUI

extension Text {
    func singleLineBodyStyle() -> some View {
        self
            .foregroundColor(.secondary)
            .font(.body)
            .lineLimit(1)
    }
}
