//
//  TripsView.swift
//  FishingTripPlanner
//
//  Created by Anton Danilov on 16/12/25.
//

import SwiftUI

struct TripCard: View {
    let trip: Trip
    
    var body: some View {
        HStack {
            Image(systemName: trip.waterType.iconName)
                .foregroundColor(.blue)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(trip.name)
                    .font(.headline)
                Text(trip.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(trip.status.rawValue.capitalized)
                .font(.caption)
                .padding(8)
                .background(trip.status == .planned ? Color.orange : Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color.teal.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

// Trips View
struct TripsView: View {
    @EnvironmentObject var appData: AppData
    @State private var filter: TripStatus = .planned
    @State private var showPlanSheet = false
    
    var filteredTrips: [Trip] {
        appData.trips.filter { $0.status == filter }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Picker("Filter", selection: $filter) {
                        Text("Planned").tag(TripStatus.planned)
                        Text("Completed").tag(TripStatus.completed)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List {
                        ForEach(filteredTrips) { trip in
                            NavigationLink(destination: TripDetailsView(tripID: trip.id)) {
                                TripCard(trip: trip)
                            }
                        }
                    }
                }
                .navigationTitle("My Trips")
            }
            .navigationViewStyle(.stack)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showPlanSheet = true }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding(20)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showPlanSheet) {
            PlanTripView()
        }
    }
}

#Preview {
    TripsView()
}
