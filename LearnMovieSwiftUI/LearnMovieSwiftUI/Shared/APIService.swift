//
//  APIService.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/19.
//

import Foundation
import Combine

public struct APIService {
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    static let apiKey = "1d9b898a212ea52e283351e521e17871"
    
    public enum APIError: Error {
        case unknown
        case apiError(reason: String)
        case networkError(error: Error)
    }
    
    public enum Endpoint {
        case popular, topRated, upcoming, nowPlaying, trending
        case movieDetail(movie: Int), recommended(movie: Int), similar(movie: Int), videos(movie: Int)
        case credits(movie: Int), review(movie: Int)
        case searchMovie, searchKeyword, searchPerson
        case popularPersons
        case personDetail(person: Int)
        case personMovieCredits(person: Int)
        case personImages(person: Int)
        case genres
        case discover
        
        func path() -> String {
            switch self {
            case .popular:
                return "movie/popular"
            case .popularPersons:
                return "person/popular"
            case .topRated:
                return "movie/top_rated"
            case .upcoming:
                return "movie/upcoming"
            case .nowPlaying:
                return "movie/now_playing"
            case .trending:
                return "trending/movie/day"
            case let .movieDetail(movie):
                return "movie/\(String(movie))"
            case let .videos(movie):
                return "movie/\(String(movie))/videos"
            case let .personDetail(person):
                return "person/\(String(person))"
            case let .credits(movie):
                return "movie/\(String(movie))/credits"
            case let .review(movie):
                return "movie/\(String(movie))/reviews"
            case let .recommended(movie):
                return "movie/\(String(movie))/recommendations"
            case let .similar(movie):
                return "movie/\(String(movie))/similar"
            case let .personMovieCredits(person):
                return "person/\(person)/movie_credits"
            case let .personImages(person):
                return "person/\(person)/images"
            case .searchMovie:
                return "search/movie"
            case .searchKeyword:
                return "search/keyword"
            case .searchPerson:
                return "search/person"
            case .genres:
                return "genre/movie/list"
            case .discover:
                return "discover/movie"
            }
        }
    }
    
    /// 请求数据
    static public func fetch<T: Codable>(endpoint: Endpoint,
                                         params: [String: String]?) -> AnyPublisher<T, APIError> {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "language", value: Locale.preferredLanguages[0])
        ]
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                switch httpResponse.statusCode {
                case 401:
                    throw APIError.apiError(reason: "Unauthorized")
                case 403:
                    throw APIError.apiError(reason: "Resource forbidden")
                case 404:
                    throw APIError.apiError(reason: "Resource not found")
                case 405..<500:
                    throw APIError.apiError(reason: "client error")
                case 500..<600:
                    throw APIError.apiError(reason: "server error")
                default: break
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let err = error as? APIError {
                    return err
                }
                if let err = error as? URLError {
                    return APIError.networkError(error: err)
                }
                return APIError.unknown
            }
            .eraseToAnyPublisher()
    }
}

