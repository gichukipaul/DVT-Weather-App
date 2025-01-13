//
//  SearchLocationsView.swift
//  DVT Weather App
//
//  Created by GICHUKI on 13/01/2025.
//

import SwiftUI

struct SearchLocationsView: View {
    @State private var location: String = ""
    @Environment(\.dismiss) var dismiss
    let onLocationSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter location name", text: $location)
                    .font(.title3)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.horizontal, 20)
                
                Button(action: {
                    guard !location.isEmpty else { return }
                    onLocationSelected(location)
                    dismiss()
                }) {
                    Text("Search Weather")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemBlue))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .navigationTitle("Search By Location")
        }
    }
}

//#Preview {
//    SearchLocationsView()
//}
