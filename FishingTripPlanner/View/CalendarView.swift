import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appData: AppData
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)! }) {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text(currentMonth, format: .dateTime.year().month())
                        .font(.headline)
                    Spacer()
                    Button(action: { currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)! }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
                let days = generateDaysInMonth(for: currentMonth)
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .bold()
                    }
                    
                    ForEach(days, id: \.self) { date in
                        Text("\(Calendar.current.component(.day, from: date))")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(hasTrips(on: date) ? Color.orange.opacity(0.3) : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Calendar")
        }
        .navigationViewStyle(.stack)
        .sheet(item: $selectedDate) { date in
            DayTripsView(date: date)
        }
    }
    
    private func generateDaysInMonth(for month: Date) -> [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: month) else { return [] }
        let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: month))!
        
        var days: [Date] = []
        for day in range {
            if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        return days
    }
    
    private func hasTrips(on date: Date) -> Bool {
        appData.trips.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

extension Date: Identifiable {
    public var id: UUID { UUID() }
}

#Preview {
    CalendarView()
}
