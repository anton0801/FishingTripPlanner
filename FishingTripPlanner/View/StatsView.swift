import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var appData: AppData
    
    var totalTrips: Int { appData.trips.count }
    var successfulTrips: Int {
        appData.trips.filter { $0.status == .completed && ($0.result == .good || $0.result == .excellent) }.count
    }
    var favoriteWaterType: String {
        let counts = Dictionary(grouping: appData.trips, by: \.waterType)
        return counts.max(by: { $0.value.count < $1.value.count })?.key.rawValue.capitalized ?? "None"
    }
    var mostTargetedFish: String {
        let allFish = appData.trips.flatMap { $0.targetFish }
        let counts = Dictionary(grouping: allFish, by: { $0 })
        return counts.max(by: { $0.value.count < $1.value.count })?.key ?? "None"
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Overview")) {
                    HStack {
                        Text("Total Trips")
                        Spacer()
                        Text("\(totalTrips)")
                    }
                    HStack {
                        Text("Successful Trips")
                        Spacer()
                        Text("\(successfulTrips)")
                    }
                    HStack {
                        Text("Favorite Water Type")
                        Spacer()
                        Text(favoriteWaterType)
                    }
                    HStack {
                        Text("Most Targeted Fish")
                        Spacer()
                        Text(mostTargetedFish)
                    }
                }
                
                Section(header: Text("Trips per Month")) {
                    SimpleBarChart(trips: appData.trips)
                }
            }
            .navigationTitle("Stats")
        }
        .navigationViewStyle(.stack)
    }
}

struct SimpleBarChart: View {
    let trips: [Trip]
    
    var monthlyCounts: [String: Int] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return Dictionary(grouping: trips, by: { formatter.string(from: $0.date) }).mapValues { $0.count }
    }
    
    var maxCount: Int { monthlyCounts.values.max() ?? 1 }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(monthlyCounts.sorted(by: { $0.key < $1.key })), id: \.key) { month, count in
                    VStack {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geometry.size.width / CGFloat(monthlyCounts.count) - 8, height: geometry.size.height * CGFloat(count) / CGFloat(maxCount))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text(month)
                            .font(.caption)
                            .rotationEffect(.degrees(-45))
                    }
                }
            }
        }
        .frame(height: 200)
        .padding()
    }
}
