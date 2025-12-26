import Foundation

class AppData: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var defaultGear: [String] = ["Rods", "Reels", "Lures", "Bait", "Tackle", "Food/Thermos"]
    @Published var units: String = "kg"
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let tripsData = UserDefaults.standard.data(forKey: "trips") {
            if let decodedTrips = try? JSONDecoder().decode([Trip].self, from: tripsData) {
                trips = decodedTrips
            }
        }
        if let gearData = UserDefaults.standard.data(forKey: "defaultGear") {
            if let decodedGear = try? JSONDecoder().decode([String].self, from: gearData) {
                defaultGear = decodedGear
            }
        }
        if let savedUnits = UserDefaults.standard.string(forKey: "units") {
            units = savedUnits
        }
    }
    
    func saveData() {
        if let tripsData = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(tripsData, forKey: "trips")
        }
        if let gearData = try? JSONEncoder().encode(defaultGear) {
            UserDefaults.standard.set(gearData, forKey: "defaultGear")
        }
        UserDefaults.standard.set(units, forKey: "units")
    }
    
    func resetData() {
        trips = []
        defaultGear = ["Rods", "Reels", "Lures", "Bait", "Tackle", "Food/Thermos"]
        units = "kg"
        saveData()
    }
}

let commonFish = ["Trout", "Bass", "Pike", "Salmon", "Carp", "Catfish", "Perch"]
