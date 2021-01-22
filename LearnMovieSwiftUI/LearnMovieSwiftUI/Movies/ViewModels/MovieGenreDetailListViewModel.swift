//
//  MovieGenreDetailListViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/22.
//

import Foundation
import Combine

final class MovieGenreDetailListViewModel: ObservableObject {
    var genre: MovieGenre?
    
    var sortBy: MoviesSort = .byPopularity
    @Published var movies = [Movie]()

    private var page: Int = 1

    let pagePublisher = PassthroughSubject<Int, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        pagePublisher
            .map { [weak self] page in
                APIService.fetch(endpoint: APIService.Endpoint.discover,
                                 params: ["page": "\(page)",
                                          "with_genres": "\(self?.genre?.id ?? 0)",
                                          "language": "zh",
                                          "region": "US",
                                          "sort_by": self?.sortBy.sortByAPI() ?? ""])
            }
            .switchToLatest()
            .decode(type: MovieListPageResponse<Movie>.self, decoder: JSONDecoder())
            .map {
                $0.results
            }
            .catch { err -> AnyPublisher<[Movie], Never> in
                print(err)
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink { [weak self] input in
                if self?.page == 1 {
                    self?.movies = input
                } else {
                    if input.isEmpty {
                        self?.page -= 1
                    } else {
                        self?.movies.append(contentsOf: input)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        pagePublisher.send(page)
    }

    func loadMoreData() {
        page += 1
        loadData()
    }
    
    func loadNewData() {
        page = 1
        loadData()
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
    }
}
