import SwiftUI

struct EditTripView: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.presentationMode) var presentationMode
    let tripID: UUID
    let trip: Trip
    
    var tripBinding: Binding<Trip> {
        Binding(
            get: { appData.trips.first { $0.id == tripID }! },
            set: { newValue in
                if let index = appData.trips.firstIndex(where: { $0.id == tripID }) {
                    appData.trips[index] = newValue
                    appData.saveData()
                }
            }
        )
    }
    
    @State private var name: String
    @State private var date: Date
    @State private var waterType: WaterType
    @State private var selectedFish: Set<String>
    @State private var notes: String
    
    init(trip: Trip) {
        self.trip = trip
        self.tripID = trip.id
        // let trip = appData.trips.first { $0.id == tripID }!
        _name = State(initialValue: trip.name)
        _date = State(initialValue: trip.date)
        _waterType = State(initialValue: trip.waterType)
        _selectedFish = State(initialValue: Set(trip.targetFish))
        _notes = State(initialValue: trip.notes)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Trip Details")) {
                    TextField("Trip Name", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Picker("Water Type", selection: $waterType) {
                        ForEach(WaterType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Target Fish")) {
                    ForEach(commonFish, id: \.self) { fish in
                        Toggle(fish, isOn: Binding(
                            get: { selectedFish.contains(fish) },
                            set: { if $0 { selectedFish.insert(fish) } else { selectedFish.remove(fish) } }
                        ))
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Edit Trip")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                tripBinding.name.wrappedValue = name
                tripBinding.date.wrappedValue = date
                tripBinding.waterType.wrappedValue = waterType
                tripBinding.targetFish.wrappedValue = Array(selectedFish)
                tripBinding.notes.wrappedValue = notes
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

