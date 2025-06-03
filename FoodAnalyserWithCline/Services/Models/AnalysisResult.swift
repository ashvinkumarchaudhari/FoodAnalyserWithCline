// filepath: /Users/spaculus/Downloads/FoodCalorieAnalyzer/FoodCalorieAnalyzer/Models/AnalysisResult.swift
import Foundation

struct AnalysisResult: Identifiable, Codable {
    let id: UUID
    let foodItem: FoodItem
    let nutritionInfo: NutritionInfo
    let analysisDate: Date
    
    init(id: UUID = UUID(), foodItem: FoodItem, nutritionInfo: NutritionInfo, analysisDate: Date = Date()) {
        self.id = id
        self.foodItem = foodItem
        self.nutritionInfo = nutritionInfo
        self.analysisDate = analysisDate
    }
}
