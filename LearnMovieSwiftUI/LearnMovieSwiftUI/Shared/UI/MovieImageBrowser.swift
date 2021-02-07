//
//  MovieImageBrowser.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/7.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieImageBrowser: View {
    let imageURLs: [String]
    @Binding var index: Int
    
    @Environment(\.presentationMode) var presentationMode
    
    @ViewBuilder private var doneBarItem: some View {
        Button("完成") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
       
        NavigationView {
            GeometryReader { reader in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        TabView(selection: $index) {
                            ForEach(0..<imageURLs.count, id: \.self) { imageIndex in
                                WebImage(url: URL(string: imageURLs[imageIndex])!)
                                    .resizable()
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFill()
                                    .frame(width: reader.size.width, height: reader.size.height)
                                    .cornerRadius(10)
                                    .tag(imageIndex)
                            }
                        }
                        .frame(width: reader.size.width, height: reader.size.height)
                        .tabViewStyle(PageTabViewStyle())
                    }
                }
        
                .navigationBarItems(trailing: doneBarItem)
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding(.horizontal, 10)
        }
    }
    
}

struct MovieImageBrowser_Previews: PreviewProvider {
    static var previews: some View {
        MovieImageBrowser(imageURLs: [], index: .constant(0))
    }
}
