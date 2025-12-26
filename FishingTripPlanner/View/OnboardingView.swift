import SwiftUI

struct OnboardingPage: View {
    let text: String
    let icon: String
    let color1: Color
    let color2: Color
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Subtle fog
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .blur(radius: 20)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                
                Text(text)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
}

// Onboarding View
struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State private var selection = 0
    
    let pages: [(text: String, icon: String, color1: Color, color2: Color)] = [
        ("Plan your fishing trips", "calendar.badge.plus", .blue, .teal),
        ("Set goals and prepare gear", "backpack.fill", .teal, .green),
        ("Review results and history", "chart.bar.fill", .green, .blue.opacity(0.8))
    ]
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPage(text: pages[index].text, icon: pages[index].icon, color1: pages[index].color1, color2: pages[index].color2)
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                HStack {
                    Button("Skip") {
                        isFirstLaunch = false
                    }
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    
                    Spacer()
                    
                    Button(selection < pages.count - 1 ? "Next" : "Start") {
                        if selection < pages.count - 1 {
                            withAnimation {
                                selection += 1
                            }
                        } else {
                            isFirstLaunch = false
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.orange)
                    .padding()
                }
                .padding(.horizontal, 20)
                .background(Color.black.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
    }
}
