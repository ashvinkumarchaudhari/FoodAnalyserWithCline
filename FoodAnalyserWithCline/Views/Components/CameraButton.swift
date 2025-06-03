// filepath: /Users/spaculus/Downloads/FoodCalorieAnalyzer/FoodCalorieAnalyzer/Views/Components/CameraButton.swift
import SwiftUI

struct CameraButton: View {
    var action: () -> Void
    var label: String
    var iconName: String
    var color: Color
    
    init(label: String = "Take Photo", iconName: String = "camera.fill", color: Color = .blue, action: @escaping () -> Void) {
        self.label = label
        self.iconName = iconName
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 20))
                
                Text(label)
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PulsatingButton: View {
    var action: () -> Void
    var color: Color
    @State private var isPulsating = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .fill(color)
                    .frame(width: 70, height: 70)
                    .scaleEffect(isPulsating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isPulsating
                    )
                
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            isPulsating = true
        }
    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CameraButton(action: {})
            
            CameraButton(
                label: "Analyze Food",
                iconName: "fork.knife",
                color: .green,
                action: {}
            )
            
            PulsatingButton(action: {}, color: .blue)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
