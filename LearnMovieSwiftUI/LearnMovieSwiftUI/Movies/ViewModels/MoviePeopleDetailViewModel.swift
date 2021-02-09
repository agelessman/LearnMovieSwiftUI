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
    @Published var yearSections: [String: [Movie]] = [:]
    @Published var yearSectionTitles: [String] = []
    
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
                                 params: ["language": "zh"])
            }
            .switchToLatest()
            .decode(type: PeopleCreditsResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] someValue in
                self?.peopleCreditsResponse = someValue
                self?.mapCreditsToYears()
            })
            .store(in: &cancellables)
    }
    
    func loadDetail(peopleId: Int) {
        detailPublisher.send(peopleId)
        imagesPublisher.send(peopleId)
        creditsPublisher.send(peopleId)
    }
    
    func mapCreditsToYears() {
        var credits:[Movie] = []
        
        if let casts = self.peopleCreditsResponse?.cast, !casts.isEmpty {
            credits.append(contentsOf: casts)
        }
        
        if let crews = self.peopleCreditsResponse?.crew, !crews.isEmpty {
            credits.append(contentsOf: crews)
        }
        
        /// 这么做的目的是过滤重复的角色，比如同一个电影中担任多个角色，以演员为主
        var creditDicts: [Int: Movie] = [:]
        for credit in credits {
            creditDicts.merge([credit.id: credit]) { (current, _) in current }
        }
        
        var yearSections: [String: [Movie]] = [:]
        
        for (_, value) in creditDicts.enumerated() {
            let movie = value.value
            if let date = movie.release_date {
                let year = String(date.prefix(4))
                if yearSections[year] == nil {
                    yearSections[year] = []
                }
                yearSections[year]?.append(movie)
            } else {
                if yearSections["即将上映"] == nil {
                    yearSections["即将上映"] = []
                }
                yearSections["即将上映"]?.append(movie)
            }
        }
        
        self.yearSections = yearSections
        self.yearSectionTitles = yearSections.compactMap { $0.key }.sorted(by: { $0 > $1})
    }
    
    deinit {
        print("=========---====-=--=-=-")
        cancellables.forEach{ $0.cancel() }
    }
}
