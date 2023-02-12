//
//  ContentView.swift
//  Project14_BucketList
//
//  Created by admin on 10.09.2022.
//
import LocalAuthentication
import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    var body: some View {
        if vm.isUnlocked {
            ZStack {
                Map(coordinateRegion: $vm.mapRegion, annotationItems: vm.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(.teal)
                                .scaledToFit()
                                .padding(10)
                                .frame(width: 50, height: 50)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Text(location.name)
                                .fixedSize()
                            
                        }
                        .onTapGesture {
                            vm.selectedLocation = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.cyan)
                    .opacity(0.2)
                    .frame(width: 20)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            vm.addLocation()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.regularMaterial)
                                
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 55, height: 55)
                            .padding()
                            
                        }
                    }
                }
            }
            .sheet(item: $vm.selectedLocation) { place in
                EditView(location: place) { newLocation in
                    vm.updateLocation(location: newLocation)
                }
            }
            
        } else {
            Button {
                vm.authenticate()
            } label: {
                Text("unlock.")
                    .font(.title)
                    .padding()
                    .background(.regularMaterial)
                    .foregroundColor(.secondary)
                    .cornerRadius(20)
                    .padding()
                    
            }
            .alert(vm.alertTitle, isPresented: $vm.showingAlert) {
                Button("Try again", role: .cancel) { vm.authenticate()}
            } message: {
                Text(vm.alertMessage)
            }
        }
        
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
