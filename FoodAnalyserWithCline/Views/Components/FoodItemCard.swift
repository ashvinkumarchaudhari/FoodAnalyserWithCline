// filepath: /Users/spaculus/Downloads/FoodCalorieAnalyzer/FoodCalorieAnalyzer/Views/Components/FoodItemCard.swift
import SwiftUI

struct FoodItemCard: View {
    let foodItem: FoodItem
    let nutritionInfo: NutritionInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageData = foodItem.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            } else if let imageName = foodItem.imageName, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
                    .overlay(
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    )
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(foodItem.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(foodItem.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(height: 40)

                HStack {
                    Label("\(Int(nutritionInfo.calories)) cal", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        NutrientBadge(label: "P", value: nutritionInfo.protein, color: .blue)
                        NutrientBadge(label: "C", value: nutritionInfo.carbohydrates, color: .green)
                        NutrientBadge(label: "F", value: nutritionInfo.fat, color: .red)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct NutrientBadge: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 2) {
            Text(label)
                .font(.system(size: 10, weight: .bold))
            
            Text("\(Int(value))")
                .font(.system(size: 10))
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .cornerRadius(4)
    }
}

// Extension for rounded specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners))
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct FoodItemCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFoodItem = FoodItem(
            name: "Greek Salad",
            description: "Fresh tomatoes, cucumbers, olives, and feta cheese with olive oil dressing",
            category: .vegetable
        )
        
        let sampleNutritionInfo = NutritionInfo(
            calories: 320,
            protein: 8,
            fat: 24,
            carbohydrates: 16,
            sugar: 6,
            fiber: 4
        )

        FoodItemCard(foodItem: sampleFoodItem, nutritionInfo: sampleNutritionInfo)
            .frame(width: 300)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
