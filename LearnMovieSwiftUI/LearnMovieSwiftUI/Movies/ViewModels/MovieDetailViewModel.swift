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
    
    let detailPublisher = PassthroughSubject<Int, Never>()

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
    }
    
    func loadDetail(movieId: Int) {
        detailPublisher.send(movieId)
    }
    
    deinit {
        print("=========---====-=--=-=-")
        cancellables.forEach{ $0.cancel() }
    }
}

