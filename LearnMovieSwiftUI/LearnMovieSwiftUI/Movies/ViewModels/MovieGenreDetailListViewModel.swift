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
    
    @Published var showLoadingMore = false
    var totalCount: Int = 0

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
            .decode(type: PaginatedResponse<Movie>.self, decoder: JSONDecoder())
            .map { [weak self] value -> [Movie] in
                self?.totalCount = value.total_results ?? 0
                return value.results
            }
            .catch { err -> AnyPublisher<[Movie], Never> in
                print(err)
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink { [weak self] someValue in
                if self?.page == 1 {
                    self?.movies = someValue
                } else {
                    if !someValue.isEmpty {
                        self?.movies.append(contentsOf: someValue)
                    }
                }
                
                if !someValue.isEmpty {
                    self?.page += 1
                }
                
                /// 是否展示加载更多
                self?.showLoadingMore = (self?.movies.count ?? 0) < (self?.totalCount ?? 0)
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        pagePublisher.send(page)
    }
    
    func loadNewData() {
        self.page = 1
        loadData()
    }
    
    deinit {
        print("=========---====-=--=-=-")
        cancellables.forEach{ $0.cancel() }
    }
}
