import SwiftUI
import Combine

class HistoryViewModel: ObservableObject {
    @Published var analyzedItems: [AnalysisResult] = []
    @Published var selectedDate: Date = Date()
    @Published var showCalendar = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadHistory()
        
        // Subscribe to selectedDate changes to automatically reload items when date changes
        $selectedDate
            .sink { [weak self] _ in
                self?.showCalendar = false
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Dummy Data Generation
    
    /// Generates dummy analysis results for testing and UI development
    static func generateDummyData() -> [AnalysisResult] {
        // Create a reference date (June 2, 2025)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 6
        dateComponents.day = 2
        let referenceDate = calendar.date(from: dateComponents) ?? Date()
        
        return [
            // TODAY'S MEALS
            // Breakfast
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Avocado Toast",
                    description: "Whole grain toast with mashed avocado, salt, and red pepper flakes",
                    category: .grain,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 280,
                    protein: 8.5,
                    fat: 16.2,
                    carbohydrates: 28.4,
                    sugar: 1.8,
                    fiber: 9.2
                ),
                analysisDate: calendar.date(byAdding: .hour, value: -8, to: referenceDate)!
            ),
            
            // Lunch
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Chicken Caesar Salad",
                    description: "Grilled chicken breast with romaine lettuce, croutons, and Caesar dressing",
                    category: .protein,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 350,
                    protein: 28.0,
                    fat: 22.5,
                    carbohydrates: 12.0,
                    sugar: 2.5,
                    fiber: 3.0
                ),
                analysisDate: calendar.date(byAdding: .hour, value: -4, to: referenceDate)!
            ),
            
            // Snack
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Greek Yogurt with Berries",
                    description: "Plain Greek yogurt topped with mixed berries and honey",
                    category: .dairy,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 180,
                    protein: 15.0,
                    fat: 4.5,
                    carbohydrates: 22.0,
                    sugar: 18.0,
                    fiber: 3.5
                ),
                analysisDate: calendar.date(byAdding: .hour, value: -2, to: referenceDate)!
            ),
            
            // YESTERDAY'S MEALS
            // Breakfast
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Spinach Omelette",
                    description: "Three-egg omelette with spinach, feta cheese, and diced tomatoes",
                    category: .protein,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 320,
                    protein: 24.0,
                    fat: 22.0,
                    carbohydrates: 6.0,
                    sugar: 3.0,
                    fiber: 2.0
                ),
                analysisDate: calendar.date(byAdding: .day, value: -1, to: referenceDate)!
            ),
            
            // Lunch
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Quinoa Bowl",
                    description: "Quinoa with roasted vegetables, chickpeas, and tahini dressing",
                    category: .grain,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 420,
                    protein: 14.0,
                    fat: 18.0,
                    carbohydrates: 52.0,
                    sugar: 8.0,
                    fiber: 12.0
                ),
                analysisDate: calendar.date(byAdding: .hour, value: -28, to: referenceDate)!
            ),
            
            // Dinner
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Grilled Salmon",
                    description: "Wild-caught salmon with lemon, dill, and a side of asparagus",
                    category: .protein,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 380,
                    protein: 34.0,
                    fat: 22.0,
                    carbohydrates: 8.0,
                    sugar: 2.0,
                    fiber: 4.0
                ),
                analysisDate: calendar.date(byAdding: .hour, value: -20, to: referenceDate)!
            ),
            
            // TWO DAYS AGO
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Acai Bowl",
                    description: "Acai puree with granola, banana slices, and mixed berries",
                    category: .fruit,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 380,
                    protein: 8.0,
                    fat: 14.0,
                    carbohydrates: 62.0,
                    sugar: 32.0,
                    fiber: 9.0
                ),
                analysisDate: calendar.date(byAdding: .day, value: -2, to: referenceDate)!
            ),
            
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Veggie Burger",
                    description: "Plant-based burger patty with lettuce, tomato, and whole-grain bun",
                    category: .vegetable,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 320,
                    protein: 18.0,
                    fat: 12.0,
                    carbohydrates: 40.0,
                    sugar: 6.0,
                    fiber: 8.0
                ),
                analysisDate: calendar.date(byAdding: .day, value: -2, to: referenceDate)!
            ),
            
            // LAST WEEK
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Tiramisu",
                    description: "Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone",
                    category: .dessert,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 420,
                    protein: 6.0,
                    fat: 24.0,
                    carbohydrates: 45.0,
                    sugar: 32.0,
                    fiber: 0.5
                ),
                analysisDate: calendar.date(byAdding: .day, value: -6, to: referenceDate)!
            ),
            
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Steak Dinner",
                    description: "Grilled ribeye steak with mashed potatoes and roasted vegetables",
                    category: .protein,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 650,
                    protein: 42.0,
                    fat: 38.0,
                    carbohydrates: 36.0,
                    sugar: 4.0,
                    fiber: 5.0
                ),
                analysisDate: calendar.date(byAdding: .day, value: -7, to: referenceDate)!
            ),
            
            // LAST MONTH
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Matcha Latte",
                    description: "Matcha green tea with steamed milk",
                    category: .beverage,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 180,
                    protein: 7.0,
                    fat: 6.0,
                    carbohydrates: 24.0,
                    sugar: 18.0,
                    fiber: 0.0
                ),
                analysisDate: calendar.date(byAdding: .month, value: -1, to: referenceDate)!
            ),
            
            AnalysisResult(
                id: UUID(),
                foodItem: FoodItem(
                    name: "Sushi Platter",
                    description: "Assortment of nigiri and maki sushi rolls",
                    category: .mixed,
                    imageData: nil
                ),
                nutritionInfo: NutritionInfo(
                    calories: 540,
                    protein: 28.0,
                    fat: 12.0,
                    carbohydrates: 80.0,
                    sugar: 6.0,
                    fiber: 4.0
                ),
                analysisDate: calendar.date(byAdding: .month, value: -1, to: referenceDate)!
            )
        ]
    }
    
    var filteredItems: [AnalysisResult] {
        return analyzedItems.filter {
            Calendar.current.isDate($0.analysisDate, inSameDayAs: selectedDate)
        }
        .sorted(by: { $0.analysisDate > $1.analysisDate })
    }
    
    func loadHistory() {
        // For testing, you can uncomment the following line to use dummy data
        // analyzedItems = Self.generateDummyData()
        analyzedItems = DataPersistenceService.shared.loadAnalyzedItems()
    }
    
    func deleteItem(at offsets: IndexSet) {
        // Get the items to delete from the filtered list
        let itemsToDelete = offsets.map { filteredItems[$0] }
        
        // Delete each item from the persistence layer
        for item in itemsToDelete {
            DataPersistenceService.shared.deleteAnalyzedItem(withId: item.id)
        }
        
        // Reload the history
        loadHistory()
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func toggleCalendar() {
        showCalendar.toggle()
    }
    
    func previousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    func nextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}
