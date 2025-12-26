import SwiftUI

struct MainView: View {
    @StateObject var appData = AppData()
    
    var body: some View {
        TabView {
            TripsView()
                .environmentObject(appData)
                .tabItem {
                    Label("Trips", systemImage: "list.bullet")
                }
            
            CalendarView()
                .environmentObject(appData)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            StatsView()
                .environmentObject(appData)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
            
            SettingsView()
                .environmentObject(appData)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.orange)
    }
}

#Preview {
    MainView()
}
