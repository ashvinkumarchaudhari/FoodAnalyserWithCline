import Foundation

struct FoodItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    let category: Category
    var imageName: String?
    var imageData: Data?
    
    init(id: UUID = UUID(), name: String, description: String, category: Category, imageName: String? = nil, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.imageName = imageName
        self.imageData = imageData
    }
    
    enum Category: String, Codable, CaseIterable {
        case fruit = "Fruit"
        case vegetable = "Vegetable"
        case grain = "Grain"
        case protein = "Protein"
        case dairy = "Dairy"
        case fat = "Fat"
        case dessert = "Dessert"
        case beverage = "Beverage"
        case mixed = "Mixed"
        case unknown = "Unknown"
    }
}
