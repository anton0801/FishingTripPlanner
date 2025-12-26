import SwiftUI

struct DayTripsView: View {
    @Environment(\.dismiss) var dis
    @EnvironmentObject var appData: AppData
    let date: Date
    
    var tripsOnDay: [Trip] {
        appData.trips.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tripsOnDay) { trip in
                    NavigationLink(destination: TripDetailsView(tripID: trip.id)) {
                        TripCard(trip: trip)
                    }
                }
            }
            .navigationTitle(date.format())
            .navigationBarItems(trailing: Button("Close") {
                dis()
            })
        }
    }
}

extension Date {
    func format() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
}
