//
//  MovieGenreDetailListViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/22.
//

import Foundation
import Combine

class MovieGenreDetailListViewModel: ObservableObject {
    var genre: MovieGenre?
    
    var sortBy: MoviesSort = .byPopularity
    @Published var movies = [Movie]()

    private var page: Int = 1

    let pagePublisher = PassthroughSubject<Int, Never>()

    var loading = false
    
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
            .decode(type: PaginatedResponse<Movie>.self, decoder: JSONDecoder())
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
                self?.loading = false
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
        if loading {
            return
        }
        page += 1
        loadData()
        loading = true
    }
    
    func loadNewData() {
        page = 1
        loadData()
    }
    
    deinit {
        print("=========---====-=--=-=-")
        cancellables.forEach{ $0.cancel() }
    }
}
