import Foundation

struct NutritionInfo: Codable {
    var calories: Double
    var protein: Double
    var fat: Double
    var carbohydrates: Double
    var sugar: Double?
    var fiber: Double?
    
    init(calories: Double, protein: Double, fat: Double, carbohydrates: Double, sugar: Double? = nil, fiber: Double? = nil) {
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbohydrates = carbohydrates
        self.sugar = sugar
        self.fiber = fiber
    }
}
