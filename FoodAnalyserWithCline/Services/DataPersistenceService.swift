import Foundation

class DataPersistenceService {
    static let shared = DataPersistenceService()
    private let analysisResultsKey = "analysisResults"
    
    private init() {}
    
    func saveAnalyzedItem(_ item: AnalysisResult) {
        var items = loadAnalyzedItems()
        items.append(item)
        saveAnalyzedItems(items)
    }
    
    func saveAnalyzedItems(_ items: [AnalysisResult]) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(items)
            UserDefaults.standard.set(encoded, forKey: analysisResultsKey)
        } catch {
            print("Error encoding analysis results: \(error.localizedDescription)")
        }
    }
    
    func loadAnalyzedItems() -> [AnalysisResult] {
        guard let data = UserDefaults.standard.data(forKey: analysisResultsKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([AnalysisResult].self, from: data)
        } catch {
            print("Error decoding analysis results: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteAnalyzedItem(withId id: UUID) {
        var items = loadAnalyzedItems()
        items.removeAll { $0.id == id }
        saveAnalyzedItems(items)
    }
    
    // Overloaded method that accepts an AnalysisResult
    func deleteAnalyzedItem(_ item: AnalysisResult) {
        deleteAnalyzedItem(withId: item.id)
    }
    
    func clearAllAnalyzedItems() {
        UserDefaults.standard.removeObject(forKey: analysisResultsKey)
    }
    
    func getAnalyzedItems(for date: Date) -> [AnalysisResult] {
        let items = loadAnalyzedItems()
        
        // Filter items to only include those from the specified date
        // (same day, regardless of time)
        return items.filter { item in
            let calendar = Calendar.current
            return calendar.isDate(item.analysisDate, inSameDayAs: date)
        }
    }
    
    func updateAnalyzedItem(_ item: AnalysisResult) {
        var items = loadAnalyzedItems()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveAnalyzedItems(items)
        }
    }
    
    func isItemSavedInHistory(id: UUID) -> Bool {
        let items = loadAnalyzedItems()
        return items.contains(where: { $0.id == id })
    }
}
