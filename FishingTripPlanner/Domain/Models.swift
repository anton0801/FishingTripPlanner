import Foundation

enum WaterType: String, Codable, CaseIterable, Identifiable {
    case river, lake, pond, sea
    
    var id: Self { self }
    
    var iconName: String {
        switch self {
        case .river: return "arrow.right.circle"
        case .lake: return "drop.fill"
        case .pond: return "drop"
        case .sea: return "water"
        }
    }
}

enum TripStatus: String, Codable {
    case planned, completed
}

enum TripResult: String, Codable, CaseIterable, Identifiable {
    case poor, good, excellent
    
    var id: Self { self }
}

struct GearItem: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var isChecked: Bool
}

struct Trip: Codable, Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var waterType: WaterType
    var targetFish: [String]
    var notes: String
    var status: TripStatus = .planned
    var result: TripResult?
    var fishCaught: String?
    var resultNotes: String?
    var gearChecklist: [GearItem]
}
