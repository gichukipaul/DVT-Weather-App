//
//  FavouritesView.swift
//  DVT Weather App
//
//  Created by GICHUKI on 13/01/2025.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.favouriteLocations.isEmpty {
                ContentUnavailableView("No favorites", systemImage: "star", description: Text("You don't have any favorites yet."))
                    .symbolVariant(.slash)
            } else {
                List {
                    ForEach(viewModel.favouriteLocations) { location in
                        HStack {
                            Text(location.name)
                                .padding(.leading, 10)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.removeFavourite(id: location.id)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

