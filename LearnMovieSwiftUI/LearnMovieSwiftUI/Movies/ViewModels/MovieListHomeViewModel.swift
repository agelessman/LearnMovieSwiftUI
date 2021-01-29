//
//  MovieListHomeViewModel.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/18.
//

import Foundation
import Combine

final class MovieListHomeViewModel: ObservableObject {
    @Published var navTitle = ""
    @Published var swapBtnImgName = ""
    @Published var homeModel: HomeMode = HomeMode.list
    @Published var selectedIndex: Int = 0
    @Published var movies = [Movie]()
    @Published var genres = [MovieGenre]()
    @Published var showLoadingMore = false
    
    private var page: Int = 1
    private var totalCount: Int = 0
    
    let pagePublisher = PassthroughSubject<Int, Never>()
    let genresPublisher = PassthroughSubject<Int, Never>()
    let navTitlePublisher = PassthroughSubject<Int, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        /// 更新mode切换
        $homeModel
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .map {
                $0.icon()
            }
            .sink {
                self.swapBtnImgName = $0
                self.loadNavTitle()
            }
            .store(in: &cancellables)
        
        /// 更新标题
        navTitlePublisher
            .map { _ in
                switch self.homeModel {
                case .grid:
                    return "Movies"
                case .list:
                    return MoviesMenu.allCases[self.selectedIndex].title()
                }
            }
            .assign(to: \.navTitle, on: self)
            .store(in: &cancellables)
        
        /// 加载更多
        pagePublisher
            .map {[weak self] page in
                APIService.fetch(endpoint: MoviesMenu.allCases[self?.selectedIndex ?? 0].endpoint(),
                                 params: ["page": "\(page)",
                                          "language": "zh",
                                          "region": "US"])
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
        
        genresPublisher
            .map { _ in
                APIService.fetch(endpoint: MoviesMenu.genres.endpoint(),
                                 params: ["language": "zh",
                                          "region": "US"])
            }
            .switchToLatest()
            .decode(type: MovieGenresResponse.self, decoder: JSONDecoder())
            .map {
                $0.genres
            }
            .catch { err -> AnyPublisher<[MovieGenre], Never> in
                print(err)
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink {
                self.genres = $0
            }
            .store(in: &cancellables)
        
        /// 选中后请求数据
        $selectedIndex
            .delay(for: 0.1, scheduler: RunLoop.main)
            .sink { _ in
                if MoviesMenu.allCases[self.selectedIndex] == MoviesMenu.genres {
                    self.genresPublisher.send(1)
                } else {
                    self.page = 1
                    self.loadData()
                }
                self.loadNavTitle()
            }
            .store(in: &cancellables)
    }
    
    func swapHomeMode() {
        homeModel == .grid ? (homeModel = .list) : (homeModel = .grid)
    }
    
    func loadData() {
        pagePublisher.send(page)
    }
    
    func loadNavTitle() {
        navTitlePublisher.send(1)
    }
}

extension MovieListHomeViewModel {
    enum HomeMode {
        case list, grid
        
        func icon() -> String {
            switch self {
            case .list: return "rectangle.3.offgrid.fill"
            case .grid: return "rectangle.grid.1x2"
            }
        }
    }
}
