import SwiftUI

struct NutritionInfoView: View {
    let nutritionInfo: NutritionInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutritional Information")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack {
                NutritionCircle(value: nutritionInfo.calories, label: "Calories", color: .orange)
                Spacer()
                NutritionCircle(value: nutritionInfo.protein, label: "Protein", unit: "g", color: .blue)
                Spacer()
                NutritionCircle(value: nutritionInfo.fat, label: "Fat", unit: "g", color: .red)
                Spacer()
                NutritionCircle(value: nutritionInfo.carbohydrates, label: "Carbs", unit: "g", color: .green)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Additional nutrition facts
            VStack(spacing: 8) {
                if let sugar = nutritionInfo.sugar {
                    NutritionDisplayRow(label: "Sugar", value: sugar, unit: "g")
                }
                
                if let fiber = nutritionInfo.fiber {
                    NutritionDisplayRow(label: "Dietary Fiber", value: fiber, unit: "g")
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct NutritionCircle: View {
    let value: Double
    let label: String
    var unit: String = ""
    let color: Color
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: min(CGFloat(value) / 100, 1.0))
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 0) {
                    Text("\(Int(value))")
                        .font(.system(size: 16, weight: .bold))
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.system(size: 10))
                    }
                }
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct NutritionDisplayRow: View {
    let label: String
    let value: Double
    let unit: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text("\(value, specifier: "%.1f") \(unit)")
                .fontWeight(.medium)
        }
    }
}

struct NutritionInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleNutritionInfo = NutritionInfo(
            calories: 250,
            protein: 15,
            fat: 10,
            carbohydrates: 30,
            sugar: 5,
            fiber: 3
        )
        
        NutritionInfoView(nutritionInfo: sampleNutritionInfo)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
