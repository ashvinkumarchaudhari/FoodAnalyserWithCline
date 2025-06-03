// filepath: /Users/spaculus/Downloads/FoodCalorieAnalyzer/FoodCalorieAnalyzer/Services/OpenAIService.swift
import Foundation
import UIKit

class OpenAIService {
    private let apiKey: String
    private let endpoint: String = "https://api.openai.com/v1/chat/completions"

    init(apiKey: String = AppConfig.openAIAPIKey) {
        self.apiKey = apiKey
    }
    
    // Analyzes food image and returns structured data about the food in the image
    func analyzeImageData(_ imageData: Data, completion: @escaping (Result<AnalysisResult, Error>) -> Void) {
        // Resize and compress the image first
        guard let image = UIImage(data: imageData),
              let processedImageData = ImageProcessor.compressImage(image: image, quality: 0.7) else {
            completion(.failure(NSError(domain: "OpenAIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])))
            return
        }
        
        let base64Image = processedImageData.base64EncodedString()
        
        // Create request body with structured format for response
        let messages: [[String: Any]] = [
            [
                "role": "system",
                "content": "You are a nutritional analysis expert. Analyze the food in the image and provide detailed nutritional information. Return JSON with the following structure: {\"name\": \"Food name\", \"description\": \"Description\", \"category\": \"Category\", \"calories\": \"Number\", \"protein\": \"Number in grams\", \"fat\": \"Number in grams\", \"carbohydrates\": \"Number in grams\", \"sugar\": \"Number in grams (optional)\", \"fiber\": \"Number in grams (optional)\"}"
            ],
            [
                "role": "user",
                "content": [
                    [
                        "type": "text",
                        "text": "What food is in this image? Analyze its nutritional content and ingredients. Return the information in JSON format."
                    ],
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(base64Image)"
                        ]
                    ]
                ]
            ]
        ]
        
     let requestBody: [String: Any] = [
         "model": "gpt-4o",  // Updated from "gpt-4-vision-preview"
         "messages": messages,
         "max_tokens": 1000,
         "response_format": ["type": "json_object"]
     ]
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "OpenAIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
//            if let dataString = String(data: data, encoding: .utf8) {
//                  print("Data as string: \(dataString)")
//              } else {
//                  print("Unable to convert data to string")
//              }
            do {
                // Parse the OpenAI response format
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let contentString = message["content"] as? String,
                   let contentData = contentString.data(using: .utf8) {
                    
                    // Parse the content JSON
                    let nutritionDict = try JSONSerialization.jsonObject(with: contentData) as? [String: Any]
                    
                    // Extract and construct our data models
                    if let name = nutritionDict?["name"] as? String,
                       let description = nutritionDict?["description"] as? String,
                       let categoryString = nutritionDict?["category"] as? String,
                       let category = self.mapStringToCategory(categoryString),
                       let calories = nutritionDict?["calories"] as? Double,
                       let protein = nutritionDict?["protein"] as? Double,
                       let fat = nutritionDict?["fat"] as? Double,
                       let carbohydrates = nutritionDict?["carbohydrates"] as? Double {
                        
                        let sugar = nutritionDict?["sugar"] as? Double
                        let fiber = nutritionDict?["fiber"] as? Double
                        
                        // Create nutrition info
                        let nutritionInfo = NutritionInfo(
                            calories: calories,
                            protein: protein,
                            fat: fat,
                            carbohydrates: carbohydrates,
                            sugar: sugar,
                            fiber: fiber
                        )
                        
                        // Create food item
                        let foodItem = FoodItem(
                            name: name,
                            description: description,
                            category: category,
                            imageData: imageData
                        )
                        
                        // Create result
                        let result = AnalysisResult(
                            foodItem: foodItem,
                            nutritionInfo: nutritionInfo
                        )
                        
                        completion(.success(result))
                        return
                    }
                }
                
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        print("Unexpected response format: \(jsonResponse["error"] ?? "Unknown error")")
                        if let errorMessage = jsonResponse["error"] as? [String:Any]
                        {
                           
                            completion(.failure(NSError(domain: "OpenAIService", code: 2, userInfo: [NSLocalizedDescriptionKey: errorMessage["message"] as? String ?? "Unknown error"])))

                        
                        }
                    } else {
                        completion(.failure(NSError(domain: "OpenAIService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])))

                    }
                // If we reach here, we failed to parse the response properly
                
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Helper function to map string categories to enum
    private func mapStringToCategory(_ categoryString: String) -> FoodItem.Category? {
        let lowerCaseCat = categoryString.lowercased()
        
        if lowerCaseCat.contains("fruit") {
            return .fruit
        } else if lowerCaseCat.contains("vegetable") {
            return .vegetable
        } else if lowerCaseCat.contains("grain") {
            return .grain
        } else if lowerCaseCat.contains("protein") || lowerCaseCat.contains("meat") {
            return .protein
        } else if lowerCaseCat.contains("dairy") {
            return .dairy
        } else if lowerCaseCat.contains("fat") {
            return .fat
        } else if lowerCaseCat.contains("dessert") {
            return .dessert
        } else if lowerCaseCat.contains("beverage") {
            return .beverage
        } else if lowerCaseCat.contains("mixed") {
            return .mixed
        } else {
            return .unknown
        }
    }
}
