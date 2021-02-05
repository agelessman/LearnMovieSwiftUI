//
//  MoviePeopleDetailViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/4.
//

import Foundation
import Combine

class MoviePeopleDetailViewModel: ObservableObject {
    @Published var people: People?
    @Published var peopleCreditsResponse: PeopleCreditsResponse?
    @Published var profiles: [ImageData] = []
    
    let detailPublisher = PassthroughSubject<Int, Never>()
    let imagesPublisher = PassthroughSubject<Int, Never>()
    let creditsPublisher = PassthroughSubject<Int, Never>()

    var cancellables = Set<AnyCancellable>()
    
    init() {
        detailPublisher
            .map { peopleId in
                APIService.fetch(endpoint: APIService.Endpoint.personDetail(person: peopleId),
                                 params: ["language": "zh"])
            }
            .switchToLatest()
            .decode(type: People.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print("===\(completion)")
            }, receiveValue: { [weak self] someValue in
                self?.people = someValue
            })
            .store(in: &cancellables)
        
        imagesPublisher
            .map { peopleId in
                APIService.fetch(endpoint: APIService.Endpoint.personImages(person: peopleId),
                                 params: nil)
            }
            .switchToLatest()
            .decode(type: ImagesResponse.self, decoder: JSONDecoder())
            .map {
                $0.profiles
            }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink { [weak self] someValue in
                self?.profiles = someValue
            }
            .store(in: &cancellables)
        
        creditsPublisher
            .map { peopleId in
                APIService.fetch(endpoint: APIService.Endpoint.personMovieCredits(person: peopleId),
                                 params: nil)
            }
            .switchToLatest()
            .decode(type: PeopleCreditsResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] someValue in
                self?.peopleCreditsResponse = someValue
            })
            .store(in: &cancellables)
    }
    
    func loadDetail(peopleId: Int) {
        detailPublisher.send(peopleId)
        imagesPublisher.send(peopleId)
        creditsPublisher.send(peopleId)
    }
    
    deinit {
        print("=========---====-=--=-=-")
        cancellables.forEach{ $0.cancel() }
    }
}
