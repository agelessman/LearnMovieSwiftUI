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
    @Published var selectedMenu: MoviesMenu = MoviesMenu.allCases.first!
    
    @Published var movies = [Movie]()
    
    
    var page: Int = 1
    
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
        $selectedMenu
            .flatMap {
                APIService.fetch(endpoint: $0.endpoint(), params: ["page": "\(self.page)",
                                                                   "region": AppUserDefaults.region])
            }
            .decode(type: MovieListPageResponse<Movie>.self, decoder: JSONDecoder())
            .map {
                $0.results
            }
            .replaceError(with: [])
            .scan([], {
                $0 + $1
            })
            .assign(to: \.movies, on: self)
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
