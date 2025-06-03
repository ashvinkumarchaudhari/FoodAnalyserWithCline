// filepath: /Users/spaculus/Documents/FoodAnalyser/FoodAnalyser/Config/AppTheme.swift
import SwiftUI

/// App-wide design configuration
struct AppTheme {
    // Primary app colors
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "3B82F6"), Color(hex: "1D4ED8")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "10B981"), Color(hex: "059669")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "F59E0B"), Color(hex: "D97706")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let neutralGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "6B7280"), Color(hex: "4B5563")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Background
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "F0F9FF"), Color(hex: "E0F2FE")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    
    // Component colors
    static let cardBackground = Color.white
    static let shadowColor = Color.black.opacity(0.1)
    
    // Dimensions
    static let cornerRadius: CGFloat = 16
    static let buttonHeight: CGFloat = 56
    static let cardPadding: CGFloat = 16
    
    // Button style
    static func primaryButton() -> some View {
        AnyView(
            primaryGradient
                .cornerRadius(cornerRadius)
                .shadow(color: Color(hex: "3B82F6").opacity(0.4), radius: 8, x: 0, y: 4)
        )
    }
    
    static func secondaryButton() -> some View {
        AnyView(
            secondaryGradient
                .cornerRadius(cornerRadius)
                .shadow(color: Color(hex: "10B981").opacity(0.4), radius: 8, x: 0, y: 4)
        )
    }
    
    // Card style
    static func cardStyle<Content: View>(_ content: Content) -> some View {
        content
            .padding(cardPadding)
            .background(cardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
    }
}
