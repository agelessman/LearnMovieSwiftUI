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
                Image(systemName: viewModel.swapBtnImgName).imageScale(.medium)
            }.frame(width: 30, height: 30)
        }
    }
    
    var body: some View {
        Group {
            ListStyle()
        }
        .background(Color.green)
        .navigationTitle(viewModel.navTitle)
        .navigationBarItems(trailing: HStack {
            swapHomeButton
        })
    }
}

struct ListStyle: View {
    var body: some View {
        Text("ListStyle")
//            .navigationTitle("00")
    }
}

struct MovieListHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListHomeView()
    }
}
