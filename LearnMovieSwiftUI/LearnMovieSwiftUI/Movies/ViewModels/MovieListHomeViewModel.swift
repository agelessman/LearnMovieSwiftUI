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
    @Published var page: Int = 1

    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        /// 更新mode切换
        $homeModel
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .map {
                $0.icon()
            }
            .assign(to: \.swapBtnImgName, on: self)
            .store(in: &cancellables)
        
        /// 更新标题
        $swapBtnImgName
            .map { _ in
                switch self.homeModel {
                case .grid:
                    return "Movies"
                case .list:
                    return "List"
                }
            }
            .assign(to: \.navTitle, on: self)
            .store(in: &cancellables)
        
        /// 选中后请求数据
        $selectedIndex
            .delay(for: 0.1, scheduler: RunLoop.main)
            .sink { _ in
                self.page = 1
            }
            .store(in: &cancellables)
        
        /// 加载更多
        $page
            .map { _ in
                APIService.fetch(endpoint: MoviesMenu.allCases[self.selectedIndex].endpoint(),
                                 params: ["page": "\(self.page)",
                                          "language": "zh",
                                          "region": "US"])
            }
            .switchToLatest()
            .decode(type: MovieListPageResponse<Movie>.self, decoder: JSONDecoder())
            .map {
                $0.results
            }
            .catch { err -> AnyPublisher<[Movie], Never> in
                print(err)
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink {
                if self.page == 1 {
                    self.movies = $0
                } else {
                    self.movies.append(contentsOf: $0)
                }
            }
            .store(in: &cancellables)
    }
    
    func swapHomeMode() {
        homeModel == .grid ? (homeModel = .list) : (homeModel = .grid)
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
