import Foundation

struct AppConfig {
    // Replace this with your actual OpenAI API key for testing
    static let openAIAPIKey = ""
    static let baseAPIURL = "https://api.openai.com/v1/chat/completions"
    
    // Maximum image dimensions to reduce API costs and bandwidth
    static let maxImageDimension: CGFloat = 800
    
    // Image compression quality (0.0-1.0)
    static let imageCompressionQuality: CGFloat = 0.7
    
    // Analysis history settings
    static let maxHistoryItems = 100
}
