//
//  ContentView-ViewModel.swift
//  Project14_BucketList
//
//  Created by admin on 11.09.2022.
//

import Foundation
import MapKit
import LocalAuthentication
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published var locations = [Location]()
        @Published var selectedLocation: Location?
        @Published var isUnlocked = false
        
        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "new location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
                save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedLocation = selectedLocation else { return }

            if let indexLocation = locations.firstIndex(of: selectedLocation) {
                locations[indexLocation] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unloc your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authentificationError in
                    if success {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 2.5)) {
                                self.isUnlocked = true
                            }
                        }
                    } else {
                        // error
                        DispatchQueue.main.async {
                            self.showingAlert = true
                            self.alertTitle = "Error"
                            self.alertMessage = "Sorry, error occured."
                        }
                    }
                }
                
            } else {
                // no biometrics
                self.showingAlert = true
                self.alertTitle = "Biometrics does not found"
                self.alertMessage = " Biometrics does not found during authentication"
            }
        }
    }
}
