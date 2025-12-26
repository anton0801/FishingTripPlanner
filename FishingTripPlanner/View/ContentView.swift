import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else if isFirstLaunch {
                OnboardingView(isFirstLaunch: $isFirstLaunch)
            } else {
                MainView()
            }
        }
    }
}

#Preview {
    ContentView()
}
