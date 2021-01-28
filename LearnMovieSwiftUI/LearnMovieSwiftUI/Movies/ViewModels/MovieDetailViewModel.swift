//
//  MovieDetailViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/27.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var error: Error?
    @Published var reviewCount: Int = 0
    
    let detailPublisher = PassthroughSubject<Int, Never>()
    let reviewPublisher = PassthroughSubject<Int, Never>()

    var cancellables = Set<AnyCancellable>()
    
    init() {
        detailPublisher
            .map { movieId in
                APIService.fetch(endpoint: APIService.Endpoint.movieDetail(movie: movieId),
                                 params: ["append_to_response": "keywords,images",
                                          "language": "zh",
                                          "region": "US"])
            }
            .switchToLatest()
            .decode(type: Movie.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let err):
                    self?.error = err
                default:
                    break
                }
            }, receiveValue: { [weak self] someValue in
                self?.movie = someValue
            })
            .store(in: &cancellables)
        
        detailPublisher
            .map { movieId in
                APIService.fetch(endpoint: APIService.Endpoint.review(movie: movieId),
                                 params: ["language": "en-US"])
            }
            .switchToLatest()
            .decode(type: PaginatedResponse<MovieReview>.self, decoder: JSONDecoder())
            .map {
                $0.total_results
            }
            .replaceNil(with: 0)
            .replaceError(with: 0)
            .receive(on: RunLoop.main)
            .sink { [weak self] someValue in
                self?.reviewCount = someValue
            }
            .store(in: &cancellables)
    }
    
    func loadDetail(movieId: Int) {
        detailPublisher.send(movieId)
        reviewPublisher.send(movieId)
    }
    
    deinit {
        print("=========---====-=--=-=-")
        cancellables.forEach{ $0.cancel() }
    }
}

