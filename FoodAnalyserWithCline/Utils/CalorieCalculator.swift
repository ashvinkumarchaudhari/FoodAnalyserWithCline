// filepath: /Users/spaculus/Downloads/FoodCalorieAnalyzer/FoodCalorieAnalyzer/Utils/CalorieCalculator.swift
import Foundation

class CalorieCalculator {
    // Multipliers for calculating calories from macronutrients
    private static let proteinCaloriesPerGram: Double = 4.0
    private static let carbsCaloriesPerGram: Double = 4.0
    private static let fatCaloriesPerGram: Double = 9.0
    
    /// Calculate total calories based on macronutrient content
    /// - Parameters:
    ///   - protein: Protein content in grams
    ///   - carbohydrates: Carbohydrate content in grams
    ///   - fat: Fat content in grams
    /// - Returns: Total calorie estimate
    static func calculateCalories(protein: Double, carbohydrates: Double, fat: Double) -> Double {
        let proteinCalories = protein * proteinCaloriesPerGram
        let carbCalories = carbohydrates * carbsCaloriesPerGram
        let fatCalories = fat * fatCaloriesPerGram
        
        return proteinCalories + carbCalories + fatCalories
    }
    
    /// Verify if the provided calorie count is consistent with macronutrients
    /// - Parameters:
    ///   - calories: Reported calories
    ///   - protein: Protein content in grams
    ///   - carbohydrates: Carbohydrate content in grams
    ///   - fat: Fat content in grams
    /// - Returns: True if the calorie count is within 10% of the calculated value
    static func verifyCalorieCount(calories: Double, protein: Double, carbohydrates: Double, fat: Double) -> Bool {
        let calculatedCalories = calculateCalories(protein: protein, carbohydrates: carbohydrates, fat: fat)
        let difference = abs(calories - calculatedCalories)
        let percentDifference = difference / calculatedCalories
        
        // Accept if within 10% margin of error
        return percentDifference <= 0.1
    }
    
    /// Adjust macronutrient values to match a target calorie count
    /// - Parameters:
    ///   - targetCalories: Target calorie count
    ///   - protein: Current protein content in grams
    ///   - carbohydrates: Current carbohydrate content in grams
    ///   - fat: Current fat content in grams
    /// - Returns: Adjusted macronutrient values as (protein, carbs, fat)
    static func adjustMacrosToMatchCalories(targetCalories: Double, protein: Double, carbohydrates: Double, fat: Double) -> (protein: Double, carbohydrates: Double, fat: Double) {
        let currentCalories = calculateCalories(protein: protein, carbohydrates: carbohydrates, fat: fat)
        if currentCalories == 0 {
            return (protein: 0, carbohydrates: 0, fat: 0)
        }
        
        let ratio = targetCalories / currentCalories
        
        return (
            protein: protein * ratio,
            carbohydrates: carbohydrates * ratio,
            fat: fat * ratio
        )
    }
    
    /// Calculate daily calorie needs based on user information
    /// - Parameters:
    ///   - weight: Weight in kg
    ///   - height: Height in cm
    ///   - age: Age in years
    ///   - isMale: True if male, false if female
    ///   - activityLevel: Activity multiplier (1.2-1.9)
    /// - Returns: Estimated daily calorie needs
    static func calculateDailyCalorieNeeds(weight: Double, height: Double, age: Double, isMale: Bool, activityLevel: Double) -> Double {
        var bmr: Double
        
        if isMale {
            bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        } else {
            bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
        }
        
        return bmr * activityLevel
    }
}
