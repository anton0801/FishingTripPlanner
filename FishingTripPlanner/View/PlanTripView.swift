import SwiftUI

struct PlanTripView: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var waterType: WaterType = .lake
    @State private var selectedFish: Set<String> = []
    @State private var notes: String = ""
    
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
            .navigationTitle("Plan New Trip")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newTrip = Trip(
                    name: name,
                    date: date,
                    waterType: waterType,
                    targetFish: Array(selectedFish),
                    notes: notes,
                    gearChecklist: appData.defaultGear.map { GearItem(name: $0, isChecked: false) }
                )
                appData.trips.append(newTrip)
                appData.saveData()
                presentationMode.wrappedValue.dismiss()
            }.disabled(name.isEmpty))
        }
    }
}
