import SwiftUI

struct SplashView: View {
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.teal.opacity(0.6), Color.green.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Fog effect
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .blur(radius: 50)
                .edgesIgnoringSafeArea(.all)
            
            // Waves
            Wave(offset: waveOffset)
                .fill(Color.blue.opacity(0.5))
                .frame(height: UIScreen.main.bounds.height)
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        waveOffset = UIScreen.main.bounds.width
                    }
                }
            
            VStack {
                Image(systemName: "sailboat.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                
                Text("Fishing Trip Planner")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            }
        }
    }
}

#Preview {
    SplashView()
}

struct Wave: Shape {
    var offset: CGFloat
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.midY))
        
        let width = rect.width
        let height = rect.height / 2
        
        for x in stride(from: 0, to: width + 10, by: 10) {
            let y = sin((x + offset) / width * 2 * .pi) * height / 4 + rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
