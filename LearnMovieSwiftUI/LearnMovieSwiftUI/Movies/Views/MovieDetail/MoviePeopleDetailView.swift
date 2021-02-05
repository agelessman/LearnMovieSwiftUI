//
//  MoviePeopleDetailView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/2.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoviePeopleDetailView: View {
    let peopleId: Int
    
    @StateObject var viewModel = MoviePeopleDetailViewModel()
    
    var body: some View {
        ZStack {
            List {
                Section {
                    if viewModel.people != nil {
                        PeopleDetailHeaderRow(people: viewModel.people!)
                    }
                    if viewModel.people?.biography?.isEmpty ?? true == false ||
                        viewModel.people?.birthDay?.isEmpty ?? true == false ||
                        viewModel.people?.deathDay?.isEmpty ?? true == false ||
                        viewModel.people?.place_of_birth?.isEmpty ?? true == false {
                        PeopleDetailBiographyRow(biography: viewModel.people?.biography,
                                                 birthDate: viewModel.people?.birthDay,
                                                 deathDate: viewModel.people?.deathDay,
                                                 placeOfBirth: viewModel.people?.place_of_birth)
                    }
                }
            }
        }
        .navigationBarTitle(viewModel.people?.name ?? "", displayMode: .automatic)
        .onAppear {
            viewModel.loadDetail(peopleId: peopleId)
        }
    }
    
    
}

struct PeopleDetailHeaderRow: View {
    let people: People
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: "https://image.tmdb.org/t/p/original/\(people.profile_path ?? "")"))
                .resizable()
                .placeholder {
                    Rectangle()
                        .foregroundColor(Color("steam_purple").opacity(0.5))
                        .frame(width: 100, height: 150)
                        .overlay(
                            Text("暂无图片")
                                .foregroundColor(.white)
                                .font(.caption)
                        )
                }
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 100, height: 150)
                .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Known for")
                    .titleStyle()
                
                if people.known_for_department != nil {
                    Text(people.known_for_department!)
                }
                
                Text(people.knownForText ?? "For now nothing much... or missing data")
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(nil)
            }
        }
    }
}

struct PeopleDetailBiographyRow: View {
    let biography: String?
    let birthDate: String?
    let deathDate: String?
    let placeOfBirth: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if (biography?.isEmpty ?? true) == false {
                Text("人物传记")
                    .titleStyle()
                    .lineLimit(1)
                
                PeopleDetailBiographyRowOverviewText(biography!, lineLimit: 6)
            }
            
            if (birthDate?.isEmpty ?? true) == false {
                Text("出生日期")
                    .titleStyle()
                    .lineLimit(1)
                
                Text(birthDate!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(1)
            }
            
            if (deathDate?.isEmpty ?? true) == false {
                Text("死亡日期")
                    .titleStyle()
                    .lineLimit(1)
                
                Text(deathDate!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(1)
            }
            
            if (placeOfBirth?.isEmpty ?? true) == false {
                Text("出生地")
                    .titleStyle()
                    .lineLimit(1)
                
                Text(placeOfBirth!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 10)
    }
    
    struct PeopleDetailBiographyRowOverviewText: View {

        /* Indicates whether the user want to see all the text or not. */
        @State private var expanded: Bool = false

        /* Indicates whether the text has been truncated in its display. */
        @State private var truncated: Bool = false

        private var text: String
        private var lineLimit: Int?

        init(_ text: String, lineLimit: Int?) {
            self.text = text
            self.lineLimit = lineLimit
        }

        private func determineTruncation(_ geometry: GeometryProxy) {
            
            // Calculate the bounding box we'd need to render the
            // text given the width from the GeometryReader.
            let total = self.text.boundingRect(
                with: CGSize(
                    width: geometry.size.width,
                    height: .greatestFiniteMagnitude
                ),
                options: .usesLineFragmentOrigin,
                attributes: [.font: UIFont.systemFont(ofSize: 16)],
                context: nil
            )

            if total.size.height > geometry.size.height {
                self.truncated = true
            }
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(self.text)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .lineLimit(self.expanded ? nil : lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            self.determineTruncation(geometry)
                        }
                    })

                if self.truncated {
                    self.toggleButton
                }
            }
        }

        var toggleButton: some View {
            Button(action: {
                self.expanded.toggle()
                self.truncated.toggle()
            }) {
                Text("展开")
                    .font(.caption)
            }
        }

    }
}
