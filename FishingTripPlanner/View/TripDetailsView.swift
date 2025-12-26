import SwiftUI

struct TripDetailsView: View {
    @EnvironmentObject var appData: AppData
    let tripID: UUID
    @State private var showResultsSheet = false
    @State private var showEditSheet = false
    
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
    
    var body: some View {
        Form {
            Section(header: Text("Trip Info")) {
                Text(tripBinding.name.wrappedValue)
                Text(tripBinding.date.wrappedValue, style: .date)
                Text("Status: \(tripBinding.status.wrappedValue.rawValue.capitalized)")
                Text("Water Type: \(tripBinding.waterType.wrappedValue.rawValue.capitalized)")
            }
            
            Section(header: Text("Target Fish")) {
                Text(tripBinding.targetFish.wrappedValue.joined(separator: ", "))
            }
            
            Section(header: Text("Notes")) {
                Text(tripBinding.notes.wrappedValue)
            }
            
            Section(header: Text("Gear Checklist")) {
                ForEach(tripBinding.gearChecklist) { $item in
                    Toggle(item.name, isOn: $item.isChecked)
                }
            }
            
            if tripBinding.status.wrappedValue == .completed {
                Section(header: Text("Results")) {
                    Text("Overall: \(tripBinding.result.wrappedValue?.rawValue.capitalized ?? "N/A")")
                    if let fish = tripBinding.fishCaught.wrappedValue {
                        Text("Fish Caught: \(fish)")
                    }
                    Text(tripBinding.resultNotes.wrappedValue ?? "")
                }
            }
        }
        .navigationTitle(tripBinding.name.wrappedValue)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit Trip") { showEditSheet = true }
                    if tripBinding.status.wrappedValue == .planned {
                        Button("Mark as Completed") { showResultsSheet = true }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showResultsSheet) {
            // TripResultsView(tripID: tripID)
            TripResultsView(tripID: tripID)
                .environmentObject(appData)
        }
        .sheet(isPresented: $showEditSheet) {
            EditTripView(trip: appData.trips.first { $0.id == tripID }!)
                .environmentObject(appData)
        }
    }
}


struct TripResultsView: View {
    @EnvironmentObject var appData: AppData
    let tripID: UUID
    @Environment(\.presentationMode) var presentationMode
    
    @State private var result: TripResult = .good
    @State private var fishCaught: String = ""
    @State private var resultNotes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Overall Result")) {
                    Picker("Result", selection: $result) {
                        ForEach(TripResult.allCases) { res in
                            Text(res.rawValue.capitalized).tag(res)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Fish Caught (Optional)")) {
                    TextField("Details", text: $fishCaught)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $resultNotes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Trip Results")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let index = appData.trips.firstIndex(where: { $0.id == tripID }) {
                    appData.trips[index].status = .completed
                    appData.trips[index].result = result
                    appData.trips[index].fishCaught = fishCaught.isEmpty ? nil : fishCaught
                    appData.trips[index].resultNotes = resultNotes
                    appData.saveData()
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}
