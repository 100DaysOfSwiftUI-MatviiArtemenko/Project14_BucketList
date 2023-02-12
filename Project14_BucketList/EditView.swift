//
//  EditView.swift
//  Project14_BucketList
//
//  Created by admin on 11.09.2022.
//

import SwiftUI

struct EditView: View {
    @StateObject private var editVM: EditViewModel
    @Environment(\.dismiss) var dismiss
    
    var location: Location
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    TextField("Name", text: $editVM.name)
                        
                    TextField("Description", text: $editVM.description)
                }
                
                .padding(.horizontal)
                
                VStack {
                    switch editVM.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        List {
                            ForEach(editVM.pages, id: \.pageid) { page in
                                Text(page.title)
                                    .font(.headline)
                                + Text(": ")
                                + Text(page.description)
                                    .font(.subheadline)
                            }
                        }
                    case .failed:
                        Text("Try egain later.")
                    }
                }
                Spacer()
                
                Button {
                    onSave(editVM.editLocation())
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.regularMaterial)
                            Image(systemName: "checkbox")
                            .resizable()
                            .padding(10)
                    }
                    .frame(width: 55, height: 55)
                }
            }
            .textFieldStyle(.roundedBorder)
            .navigationTitle("place details")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await editVM.fetchNearbyPlaces()
        }
        }

    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _editVM = StateObject(wrappedValue: EditViewModel(location: location))
    }
    
    
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location(id: UUID(), name: "New", description: "Description", latitude: 0.0, longitude: 50.0)) { _ in }
    }
}
