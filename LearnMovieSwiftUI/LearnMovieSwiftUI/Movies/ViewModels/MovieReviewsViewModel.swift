//
//  MovieReviewsViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/29.
//

import Foundation
import Combine

class MovieReviewsViewModel: ObservableObject {
    @Published var reviews: [MovieReview] = []
    @Published var showLoadingMore = false
    
    var movieId: Int?

    var totalCount: Int = 0
    private var page: Int = 1
    
    private let pagePublisher = PassthroughSubject<Int, Never>()

    var cancellables = Set<AnyCancellable>()
    
    init() {
        pagePublisher
            .map { [weak self] page in
                APIService.fetch(endpoint: APIService.Endpoint.review(movie: self?.movieId ?? 0),
                                 params: ["language": "en-US", "page": "\(page)"])
            }
            .switchToLatest()
            .decode(type: PaginatedResponse<MovieReview>.self, decoder: JSONDecoder())
            .map { [weak self] value -> [MovieReview] in
                self?.totalCount = value.total_results ?? 0
                return value.results
            }
            .replaceNil(with: [])
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink { [weak self] someValue in
                if self?.page == 1 {
                    self?.reviews = someValue
                } else {
                    if !someValue.isEmpty {
                        self?.reviews.append(contentsOf: someValue)
                    }
                }
                
                if !someValue.isEmpty {
                    self?.page += 1
                }
                
                /// 是否展示加载更多
                self?.showLoadingMore = (self?.reviews.count ?? 0) < (self?.totalCount ?? 0)
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        pagePublisher.send(page)
    }

    deinit {
        print("=========---====-=--=-=-")
        cancellables.forEach{ $0.cancel() }
    }
}
