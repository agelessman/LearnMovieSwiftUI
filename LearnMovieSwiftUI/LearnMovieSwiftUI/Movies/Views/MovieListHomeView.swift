//
//  MovieListHomeView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/1/18.
//

import SwiftUI

struct MovieListHomeView: View {
    @StateObject var viewModel = MovieListHomeViewModel()
    
    private var swapHomeButton: some View {
        Button(action: {
            viewModel.swapHomeMode()
        }) {
            HStack {
                Image(systemName: viewModel.swapBtnImgName)
                    .imageScale(.medium)
            }.frame(width: 30, height: 30)
        }
    }
    
    private var settingButton: some View {
        Button(action: {
            
        }) {
            HStack {
                Image(systemName: "wrench")
                    .imageScale(.medium)
            }.frame(width: 30, height: 30)
        }
    }
    
    var body: some View {
        Group {
            MovieListView(movies: viewModel.movies,
                          selectedIndex: $viewModel.selectedIndex,
                          page: $viewModel.page)
        }
        .navigationBarTitle(viewModel.navTitle, displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            swapHomeButton
            settingButton
        })
    }
}

struct MovieListHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListHomeView()
    }
}
