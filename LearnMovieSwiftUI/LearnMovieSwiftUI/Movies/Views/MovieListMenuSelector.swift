//
//  MovieListMenuSelector.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/20.
//

import SwiftUI

struct MovieListMenuSelector: View {
    let menus: [MoviesMenu]
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                HStack {
                    ForEach(0..<menus.count) { index in
                        MenuSelectorItem(title: menus[index].title(),
                                         index: index,
                                         selected: selectedIndex == index)
                            .id(index) /// 需要绑定id
                            .onTapGesture {
                                if self.selectedIndex != index {
                                    withAnimation {
                                        self.selectedIndex = index
                                        
                                        /// 滚动到可见区域
                                        scrollViewProxy.scrollTo(index, anchor: .trailing)
                                    }
                                }
                            }
                    }
                }
            }
        }
        .backgroundPreferenceValue(MenuSelectorPreferenceKey.self, { preferences in
            GeometryReader { reader in
                self.createBottomLine(reader, preferences: preferences)
            }
        })
        .padding(.horizontal, 10)
        .background(Color.white)
    }
    
    func createBottomLine(_ proxy: GeometryProxy, preferences: [MenuSelectorPreferenceData]) -> some View {
        let p = preferences.first(where: { $0.viewIdx == self.selectedIndex })

        let bounds = proxy[p!.bounds]
        
        return RoundedRectangle(cornerRadius: 2.5)
            .foregroundColor(Color("steam_purple"))
            .frame(width: bounds.width - 10, height: 3)
            .offset(x: bounds.minX + 5, y: bounds.height - 3)
    }
}

struct MenuSelectorItem: View {
    let title: String
    let index: Int
    let selected: Bool
    
    var body: some View {
        Text(title)
            .foregroundColor(selected ? Color("steam_purple") : .secondary)
            .scaleEffect(selected ? 1.2 : 1.0)
            .padding(10)
            .anchorPreference(key: MenuSelectorPreferenceKey.self, value: .bounds, transform: {
                [MenuSelectorPreferenceData(viewIdx: index, bounds: $0)]
            })
    }
}

struct MenuSelectorPreferenceData {
    let viewIdx: Int
    let bounds: Anchor<CGRect>
}

struct MenuSelectorPreferenceKey: PreferenceKey {
    typealias Value = [MenuSelectorPreferenceData]
    static var defaultValue: [MenuSelectorPreferenceData] = []
    static func reduce(value: inout [MenuSelectorPreferenceData], nextValue: () -> [MenuSelectorPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MovieListMenuSelector_Previews: PreviewProvider {
    static var previews: some View {
        MovieListMenuSelector(menus: MoviesMenu.allCases,
                              selectedIndex: .constant(0))
    }
}
