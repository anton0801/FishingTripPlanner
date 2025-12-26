import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appData: AppData
    @State private var showExportSheet = false
    @State private var notes: String = UserDefaults.standard.string(forKey: "generalNotes") ?? ""
    @State private var showShare = false
    @State private var csvURL: URL?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Units")) {
                    Picker("Weight Units", selection: $appData.units) {
                        Text("kg").tag("kg")
                        Text("lb").tag("lb")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Default Checklist")) {
                    List {
                        ForEach($appData.defaultGear, id: \.self) { $item in
                            TextField("Item", text: $item)
                        }
                        .onDelete { indices in
                            appData.defaultGear.remove(atOffsets: indices)
                            appData.saveData()
                        }
                    }
                    Button("Add Item") {
                        appData.defaultGear.append("")
                        appData.saveData()
                    }
                }
                
                Section(header: Text("General Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .onChange(of: notes) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "generalNotes")
                        }
                }
                
                Section {
                    Button("Reset Data", role: .destructive) {
                        appData.resetData()
                    }
                }
                
                Section(header: Text("About")) {
                    Text("Fishing Trip Planner v1.0")
                    Text("Privacy Policy: Your data stays on your device.")
                }
            }
            .navigationTitle("Settings")
        }
        .navigationViewStyle(.stack)
    }
    
}
