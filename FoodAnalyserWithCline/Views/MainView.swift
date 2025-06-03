import SwiftUI
import UIKit

struct CardButtonView: View {
    let title: String
    let subtitle: String
    let icon: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                // Glass-morphic background with border
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .opacity(0.7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing),
                                lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing))
                            .frame(width: 50, height: 50)
                            
                        Image(systemName: icon)
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 20)
                }
            }
            .frame(height: 90)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MainView: View {
    @State private var showAnimation = false
    @State private var isShowingUI = false
    
    // Match CameraView styling
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "121212"), Color(hex: "1E1E1E")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    private let accentColor1 = Color(hex: "4F46E5") // Indigo
    private let accentColor2 = Color(hex: "7C3AED") // Violet
    
    // Design constants matching CameraView
    private let cornerRadius: CGFloat = 16
    private let shadowColor = Color.black.opacity(0.1)
    private let textPrimary = Color(hex: "1E293B")
    private let textSecondary = Color(hex: "64748B")
    private let cardBackground = Color.white
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dark gradient background
                backgroundGradient
                    .ignoresSafeArea()
                
                // Accent circles for visual interest
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [accentColor1.opacity(0.6), accentColor1.opacity(0)]),
                            center: .center,
                            startRadius: 1,
                            endRadius: 300
                        )
                    )
                    .frame(width: 500, height: 500)
                    .position(x: -50, y: 200)
                
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [accentColor2.opacity(0.6), accentColor2.opacity(0)]),
                            center: .center,
                            startRadius: 1,
                            endRadius: 300
                        )
                    )
                    .frame(width: 500, height: 500)
                    .position(x: UIScreen.main.bounds.width + 50, y: 600)
                
                // Main content
                VStack(spacing: 0) {
                    // App header
                    HStack {
                        // Left side is empty for balance
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 44, height: 44)
                        
                        Spacer()
                        
                        Text("Food Analyzer")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Right side is empty for balance
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 44, height: 44)
                    }
                    .padding([.horizontal, .top])
                    
                    // App logo
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .padding(.top, 10)
                    
                    Text("Track nutrition in your meals")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 20)
                    
                    // Main menu cards with glass-morphic style
                    ScrollView {
                        VStack(spacing: 16) {
                            CardButtonView(
                                title: "Scan Food",
                                subtitle: "Analyze your meal with camera",
                                icon: "camera.viewfinder",
                                destination: AnyView(CameraView())
                            )
                            .scaleEffect(showAnimation ? 1 : 0.95)
                            .opacity(showAnimation ? 1 : 0.7)
                            .animation(.easeOut(duration: 0.3).delay(0.1), value: showAnimation)
                            
                            CardButtonView(
                                title: "Analysis Results",
                                subtitle: "View your recent food analysis",
                                icon: "chart.pie.fill",
                                destination: AnyView(CameraView())
                            )
                            .scaleEffect(showAnimation ? 1 : 0.95)
                            .opacity(showAnimation ? 1 : 0.7)
                            .animation(.easeOut(duration: 0.3).delay(0.2), value: showAnimation)
                            
                            CardButtonView(
                                title: "History",
                                subtitle: "Browse previous analyses",
                                icon: "clock.fill",
                                destination: AnyView(HistoryView())
                            )
                            .scaleEffect(showAnimation ? 1 : 0.95)
                            .opacity(showAnimation ? 1 : 0.7)
                            .animation(.easeOut(duration: 0.3).delay(0.3), value: showAnimation)
                            
                            CardButtonView(
                                title: "Settings",
                                subtitle: "Configure app preferences",
                                icon: "gearshape.fill",
                                destination: AnyView(SettingsView())
                            )
                            .scaleEffect(showAnimation ? 1 : 0.95)
                            .opacity(showAnimation ? 1 : 0.7)
                            .animation(.easeOut(duration: 0.3).delay(0.4), value: showAnimation)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .opacity(isShowingUI ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isShowingUI)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                withAnimation {
                    showAnimation = true
                }
                
                // Fade in UI elements like in CameraView
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isShowingUI = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// Extension for hex color support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
