//
//  MoviePeopleDetailView.swift
//  LearnMovieSwiftUI
//
//  Created by MC on 2021/2/2.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreData

struct MoviePeopleDetailView: View {
    let peopleId: Int
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FanClubPeople.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<FanClubPeople>
    
    @StateObject var viewModel = MoviePeopleDetailViewModel()
    @State private var selectedPosterIndex: Int = 0
    
    @ViewBuilder private var headerRow: some View {
        if viewModel.people != nil {
            PeopleDetailHeaderRow(people: viewModel.people!)
        }
    }
    
    @ViewBuilder private var biographyRow: some View {
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
    
    @ViewBuilder private var barButtons: some View {
        if viewModel.people != nil {
            Button(action: {
                if isFanClub() {
                    deleteItems(viewModel.people!)
                } else {
                    addItem(viewModel.people!)
                }
            }, label: {
                Image(systemName: isFanClub() ? "star.circle.fill" : "star.circle")
                    .resizable()
                    .foregroundColor(isFanClub() ? .steam_theme : .primary)
                    .scaleEffect(isFanClub() ? 1.1 : 1.0)
                    .frame(width: 25, height: 25)
                    .animation(.spring())
            })
        }
    }
    
    @ViewBuilder private var imagesRow: some View {
        if !viewModel.profiles.isEmpty {
            MoviePeopleDetailImagesRow(images: viewModel.profiles)
        }
    }
    
    @ViewBuilder private var creditsSections: some View {
        ForEach(viewModel.yearSectionTitles, id: \.self) { year in
            Section(header: Text(year)) {
                ForEach(viewModel.yearSections[year]!) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                        MoviePeopleDetailMovieRow(movie: movie)
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            List {
                Section {
                    headerRow
                    biographyRow
                    imagesRow
                }
                
                creditsSections
            }
        }
        .navigationBarTitle(viewModel.people?.name ?? "", displayMode: .automatic)
        .navigationBarItems(trailing: barButtons)
        .onAppear {
            viewModel.loadDetail(peopleId: peopleId)
        }
    }
    
    private func isFanClub() -> Bool {
        guard let _ = items.firstIndex(where: { $0.id == peopleId })  else {
            return false
        }
        return true
    }
    
    private func addItem(_ people: People) {
        withAnimation {
            let newItem = FanClubPeople(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = people.name
            newItem.id = Int64(people.id)
            newItem.imageURL = people.profile_path ?? ""

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(_ people: People) {
        withAnimation {
            var offsets = IndexSet()
            let index = items.firstIndex(where: { $0.id == people.id })
            guard let i = index else { return }
            offsets.insert(i)
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
                    .singleLineBodyStyle()
            }
            
            if (deathDate?.isEmpty ?? true) == false {
                Text("死亡日期")
                    .titleStyle()
                    .lineLimit(1)
                
                Text(deathDate!)
                    .singleLineBodyStyle()
            }
            
            if (placeOfBirth?.isEmpty ?? true) == false {
                Text("出生地")
                    .titleStyle()
                    .lineLimit(1)
                
                Text(placeOfBirth!)
                    .singleLineBodyStyle()
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
