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
    @Published var genres = [MovieGenre]()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        let menuPublisher = MoviesMenu.allCases.filter{ $0 != .genres }.publisher
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
            .eraseToAnyPublisher()
            
        let genrePublisher = [MoviesMenu.genres].publisher
            .map { _ in
                APIService.fetch(endpoint: MoviesMenu.genres.endpoint(),
                                 params: ["language": "zh",
                                          "region": "US"])
            }
            .switchToLatest()
            .decode(type: MovieGenresResponse.self, decoder: JSONDecoder())
            .map {
                $0.genres
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()

        menuPublisher
            .combineLatest(genrePublisher)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.movies = $0.0
                self?.genres = $0.1
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
    }
}
