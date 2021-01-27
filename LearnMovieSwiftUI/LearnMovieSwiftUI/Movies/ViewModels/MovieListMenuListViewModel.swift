//
//  MovieListMenuListViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/27.
//

import Foundation
import Combine

class MovieListMenuListViewModel: ObservableObject {
    var menu: MoviesMenu?
    
    @Published var movies = [Movie]()

    private var page: Int = 1

    let pagePublisher = PassthroughSubject<Int, Never>()

    var loading = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        pagePublisher
            .map { [weak self] page in
                APIService.fetch(endpoint: self?.menu?.endpoint() ?? APIService.Endpoint.nowPlaying,
                                 params: ["page": "\(page)",
                                          "language": "zh",
                                          "region": "US"])
            }
            .switchToLatest()
            .decode(type: MovieListPageResponse<Movie>.self, decoder: JSONDecoder())
            .map {
                $0.results
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
