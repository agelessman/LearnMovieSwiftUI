//
//  MovieListGridViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/26.
//

import Foundation
import Combine

class MovieListGridViewModel: ObservableObject {
    @Published var movies: [(MoviesMenu, [Movie])] = []
    
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        MoviesMenu.allCases.filter{ $0 != .genres }.publisher
            .flatMap { menu -> AnyPublisher<(MoviesMenu, [Movie]), Never> in
                APIService.fetch(endpoint: menu.endpoint(),
                                 params: ["page": "\(1)",
                                          "language": "zh",
                                          "region": "US"])
                    .decode(type: MovieListPageResponse<Movie>.self, decoder: JSONDecoder())
                    .map {
                        (menu, $0.results)
                    }
                    .replaceError(with: (menu, []))
                    .eraseToAnyPublisher()
            }
            .collect()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.movies = $0
            }
            .store(in: &cancellables)
    }
}
