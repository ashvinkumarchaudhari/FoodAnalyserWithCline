// filepath: /Users/spaculus/Downloads/FoodCalorieAnalyzer/FoodCalorieAnalyzer/Views/SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @State private var apiKey: String = AppConfig.openAIAPIKey
    @State private var saveApiKey: Bool = false
    @State private var showClearHistoryConfirmation = false
    @AppStorage("useOptimizedImages") private var useOptimizedImages = true
    @AppStorage("imageCompression") private var imageCompression = 0.7
    private let accentColor1 = Color(hex: "4F46E5") // Indigo
    private let accentColor2 = Color(hex: "7C3AED") // Violet
    // Define design constants
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "121212"), Color(hex: "1E1E1E")]),
        startPoint: .top,
        endPoint: .bottom
    )
    private let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "3B82F6"), Color(hex: "1D4ED8")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    private let secondaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "10B981"), Color(hex: "059669")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
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
                Form {
                    Section(header: Text("API Configuration").foregroundColor(.white)) {
                        SecureField("OpenAI API Key", text: $apiKey)
                        Toggle("Save API Key", isOn: $saveApiKey)
                            .onChange(of: saveApiKey) { oldValue, newValue in
                                if newValue {
                                    saveApiKeyToKeychain()
                                } else {
                                    removeApiKeyFromKeychain()
                                }
                            }
                        Button("Test API Connection") {
                            testApiConnection()
                        }
                    }
                    
                    Section(header: Text("Image Optimization").foregroundColor(.white)) {
                        Toggle("Optimize Images", isOn: $useOptimizedImages)
                        
                        VStack(alignment: .leading) {
                            Text("Compression Quality: \(Int(imageCompression * 100))%")
                            Slider(value: $imageCompression, in: 0.1...1.0, step: 0.1)
                        }
                    }
                    
                    Section(header: Text("Data Management").foregroundColor(.white)) {
                        Button(action: {
                            showClearHistoryConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                Text("Clear Analysis History")
                                    .foregroundColor(.red)
                            }
                        }
                        .alert(isPresented: $showClearHistoryConfirmation) {
                            Alert(
                                title: Text("Clear History"),
                                message: Text("Are you sure you want to delete all analyzed food items? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete All")) {
                                    DataPersistenceService.shared.clearAllAnalyzedItems()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    
                    Section(header: Text("About") .foregroundColor(.white)) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                        
                        Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                        Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                    }

                }
                .scrollContentBackground(.hidden) // Hides the default background
                .background(Color.clear)
                .navigationTitle("Settings")
                
            }
        }
        .colorScheme(.dark)
        .onAppear {
            loadSettings()
        }
      
    }
    
    private func loadSettings() {
        if let keyFromKeychain = loadApiKeyFromKeychain() {
            apiKey = keyFromKeychain
            saveApiKey = true
        }
    }
    
    private func saveApiKeyToKeychain() {
        // For simplicity, just using UserDefaults in this example
        // In a real app, use Keychain for sensitive data
        UserDefaults.standard.set(apiKey, forKey: "openai_api_key")
    }
    
    private func removeApiKeyFromKeychain() {
        UserDefaults.standard.removeObject(forKey: "openai_api_key")
    }
    
    private func loadApiKeyFromKeychain() -> String? {
        return UserDefaults.standard.string(forKey: "openai_api_key")
    }
    
    private func testApiConnection() {
        // In a real app, implement API connection test
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
