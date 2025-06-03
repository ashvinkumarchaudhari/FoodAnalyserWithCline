// filepath: /Users/spaculus/Downloads/FoodCalorieAnalyzer/FoodCalorieAnalyzer/Services/ImageAnalysisService.swift
import Foundation
import UIKit

class ImageAnalysisService {
    private let openAIService: OpenAIService
    
    init(openAIService: OpenAIService = OpenAIService()) {
        self.openAIService = openAIService
    }
    
    func analyzeImage(_ image: UIImage, completion: @escaping (Result<AnalysisResult, Error>) -> Void) {
        // Convert the image to data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageAnalysisService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image conversion failed."])))
            return
        }
        
        // Call OpenAIService to analyze the image
        openAIService.analyzeImageData(imageData) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
