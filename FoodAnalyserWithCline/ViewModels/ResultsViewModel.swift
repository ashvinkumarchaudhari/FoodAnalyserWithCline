import SwiftUI
import Combine

class ResultsViewModel: ObservableObject {
    @Published var editedFoodItem: FoodItem
    @Published var editedNutritionInfo: NutritionInfo
    @Published var isEditing = false
    @Published var isSavedToHistory: Bool
    
    private let originalResult: AnalysisResult
    
    init(analysisResult: AnalysisResult) {
        self.originalResult = analysisResult
        self.editedFoodItem = analysisResult.foodItem
        self.editedNutritionInfo = analysisResult.nutritionInfo
        // Check if this result is already saved in history
        self.isSavedToHistory = DataPersistenceService.shared.isItemSavedInHistory(id: analysisResult.id)
    }
    
    func saveChanges() {
        let updatedResult = AnalysisResult(
            id: originalResult.id,
            foodItem: editedFoodItem,
            nutritionInfo: editedNutritionInfo,
            analysisDate: originalResult.analysisDate
        )
        
        DataPersistenceService.shared.updateAnalyzedItem(updatedResult)
    }
    
    func saveToHistory() {
        let result = AnalysisResult(
            id: originalResult.id,
            foodItem: editedFoodItem,
            nutritionInfo: editedNutritionInfo,
            analysisDate: originalResult.analysisDate
        )
        
        DataPersistenceService.shared.saveAnalyzedItem(result)
        isSavedToHistory = true
    }
    
    func resetChanges() {
        editedFoodItem = originalResult.foodItem
        editedNutritionInfo = originalResult.nutritionInfo
    }
    
    func toggleEditing() {
        isEditing.toggle()
        if (!isEditing) {
            // When exiting edit mode, save changes
            saveChanges()
        }
    }
}
