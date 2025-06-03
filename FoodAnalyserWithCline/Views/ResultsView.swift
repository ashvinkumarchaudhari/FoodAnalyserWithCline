import SwiftUI

struct NutritionProgressBar: View {
    let value: Double
    let maxValue: Double
    let color: Color
    let label: String
    let valueText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
//                    .foregroundColor(Color(hex: "475569"))
                    .foregroundColor(.white.opacity(0.8))

                Spacer()
                
                Text(valueText)
                    .font(.subheadline.bold())
                    .foregroundColor(color)
            }
            
            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .fill(color.opacity(0.15))
                    .frame(height: 10)
                    .cornerRadius(5)
                
                // Progress bar
                Rectangle()
                    .fill(color)
                    .frame(width: max(CGFloat(value) / CGFloat(maxValue) * UIScreen.main.bounds.width * 0.85, 15), height: 10)
                    .cornerRadius(5)
            }
        }
    }
}

struct ResultsView: View {
    var analysisResult: AnalysisResult
    @StateObject private var viewModel: ResultsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showShareSheet = false
    @State private var showSavedConfirmation = false
    private let accentColor1 = Color(hex: "4F46E5") // Indigo
    private let accentColor2 = Color(hex: "7C3AED") // Violet
    // Define design constants
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "121212"), Color(hex: "1E1E1E")]),
        startPoint: .top,
        endPoint: .bottom
    )
    private let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "3B82F6"), Color(hex: "1D4ED8")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    private let secondaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "10B981"), Color(hex: "059669")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    init(analysisResult: AnalysisResult) {
        self.analysisResult = analysisResult
        _viewModel = StateObject(wrappedValue: ResultsViewModel(analysisResult: analysisResult))
    }

    var body: some View {
        ZStack {
//            // Background
//            Color(hex: "F8FAFC")
//                .ignoresSafeArea()
            
            // Background
            backgroundGradient
                .ignoresSafeArea()
            // Accent circles for visual interest
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [accentColor1.opacity(0.6), accentColor1.opacity(0)]),
                        center: .center,
                        startRadius: 1,
                        endRadius: 300
                    )
                )
                .frame(width: 500, height: 500)
                .position(x: -50, y: 200)
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [accentColor2.opacity(0.6), accentColor2.opacity(0)]),
                        center: .center,
                        startRadius: 1,
                        endRadius: 300
                    )
                )
                .frame(width: 500, height: 500)
                .position(x: UIScreen.main.bounds.width + 50, y: 600)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header with back button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(Color(hex: "334155"))
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        Spacer()
                        
                        Text("Analysis Results")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Edit/Save button
                        Button(action: {
                            if viewModel.isEditing {
                                viewModel.saveChanges()
                                showSavedConfirmation = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    showSavedConfirmation = false
                                }
                            } else {
                                viewModel.isEditing.toggle()
                            }
                        }) {
                            Image(systemName: viewModel.isEditing ? "checkmark" : "pencil")
                                .font(.headline)
                                .foregroundColor(viewModel.isEditing ? Color(hex: "10B981") : Color(hex: "334155"))
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Food info card
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomTrailing) {
                            if let imageData = viewModel.editedFoodItem.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .clipped()
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .padding(40)
                                    .foregroundColor(Color(hex: "94A3B8"))
                                    .background(Color(hex: "E2E8F0"))
                            }
                            
                            // Category tag
                            Text(viewModel.editedFoodItem.category.rawValue)
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: "3B82F6"))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .padding(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            if viewModel.isEditing {
                                TextField("Food name", text: $viewModel.editedFoodItem.name)
                                    .font(.title3.bold())
                                    .padding(.vertical, 4)
                                    .foregroundColor(.white)
                                
                                TextField("Description", text: $viewModel.editedFoodItem.description)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            } else {
                                Text(viewModel.editedFoodItem.name)
                                    .font(.title3.bold())
                                    .foregroundColor(.white)

                                Text(viewModel.editedFoodItem.description)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding()
//                        .background(Color.white.opacity(0.5))
                    }
                    .background(Color(hex: "4F46E5").opacity(0.5))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Nutrition card
                    VStack(alignment: .leading, spacing: 20) {
                        // Card header
                        HStack {
                            Text("Nutritional Information")
                                .font(.title3.bold())
                                .foregroundColor(.white)

                            Spacer()
                            
                            // Share button
                            Button(action: {
                                showShareSheet = true
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Nutrition summary
                        HStack(spacing: 15) {
                            // Calories circle
                            VStack {
                                ZStack {
                                    Circle()
                                        .stroke(
                                            Color(hex: "F43F5E").opacity(0.2),
                                            lineWidth: 10
                                        )
                                    
                                    Circle()
                                        .trim(from: 0, to: min(CGFloat(viewModel.editedNutritionInfo.calories) / 1000, 1))
                                        .stroke(
                                            Color(hex: "F43F5E"),
                                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                        )
                                        .rotationEffect(.degrees(-90))
                                    
                                    VStack(spacing: 0) {
                                        if viewModel.isEditing {
                                            TextField("", value: $viewModel.editedNutritionInfo.calories, formatter: NumberFormatter())
                                                .keyboardType(.decimalPad)
                                                .multilineTextAlignment(.center)
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white.opacity(0.8))
                                        } else {
                                            Text("\(Int(viewModel.editedNutritionInfo.calories))")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        
                                        Text("kcal")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                .frame(width: 90, height: 90)
                                
                                Text("Calories")
                                    .font(.footnote.bold())
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            // Macronutrient distribution
                            VStack(alignment: .leading, spacing: 8) {
                                if viewModel.isEditing {
                                    HStack {
                                        Text("Protein")
                                            .font(.callout)
                                        
                                        TextField("", value: $viewModel.editedNutritionInfo.protein, formatter: NumberFormatter())
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                        
                                        Text("g")
                                            .font(.callout)
                                    }
                                    
                                    HStack {
                                        Text("Carbs")
                                            .font(.callout)
                                        
                                        TextField("", value: $viewModel.editedNutritionInfo.carbohydrates, formatter: NumberFormatter())
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                        
                                        Text("g")
                                            .font(.callout)
                                    }
                                    
                                    HStack {
                                        Text("Fat")
                                            .font(.callout)
                                        
                                        TextField("", value: $viewModel.editedNutritionInfo.fat, formatter: NumberFormatter())
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                        
                                        Text("g")
                                            .font(.callout)
                                    }
                                } else {
                                    let total = viewModel.editedNutritionInfo.protein + viewModel.editedNutritionInfo.carbohydrates + viewModel.editedNutritionInfo.fat
                                    
                                    NutritionProgressBar(
                                        value: viewModel.editedNutritionInfo.protein,
                                        maxValue: total,
                                        color: Color(hex: "3B82F6"),
                                        label: "Protein",
                                        valueText: "\(Int(viewModel.editedNutritionInfo.protein))g"
                                    )
                                    
                                    NutritionProgressBar(
                                        value: viewModel.editedNutritionInfo.carbohydrates,
                                        maxValue: total,
                                        color: Color(hex: "10B981"),
                                        label: "Carbohydrates",
                                        valueText: "\(Int(viewModel.editedNutritionInfo.carbohydrates))g"
                                    )
                                    
                                    NutritionProgressBar(
                                        value: viewModel.editedNutritionInfo.fat,
                                        maxValue: total,
                                        color: Color(hex: "F59E0B"),
                                        label: "Fat",
                                        valueText: "\(Int(viewModel.editedNutritionInfo.fat))g"
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        Divider()
                        
                        // Additional nutrients
                        VStack(spacing: 12) {
                            if let sugar = viewModel.editedNutritionInfo.sugar {
                                HStack {
                                    Text("Sugar")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))

                                    Spacer()
                                    
                                    if viewModel.isEditing {
                                        let sugarBinding = Binding<Double>(
                                            get: { sugar },
                                            set: { viewModel.editedNutritionInfo.sugar = $0 }
                                        )
                                        
                                        TextField("", value: sugarBinding, formatter: NumberFormatter())
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 50)
                                        
                                        Text("g")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                    } else {
                                        Text("\(Int(sugar))g")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                            }
                            
                            if let fiber = viewModel.editedNutritionInfo.fiber {
                                HStack {
                                    Text("Fiber")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))

                                    Spacer()
                                    
                                    if viewModel.isEditing {
                                        let fiberBinding = Binding<Double>(
                                            get: { fiber },
                                            set: { viewModel.editedNutritionInfo.fiber = $0 }
                                        )
                                        
                                        TextField("", value: fiberBinding, formatter: NumberFormatter())
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 50)
                                        
                                        Text("g")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                    } else {
                                        Text("\(Int(fiber))g")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                            }
                            
                            // Add more nutrient rows as needed
                        }
                    }
                    .padding()
//                    .background(Color.white.opacity(0.5))
                    .background(Color(hex: "4F46E5").opacity(0.5))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Save to history button (if not already saved)
                    if !viewModel.isSavedToHistory {
                        Button(action: viewModel.saveToHistory) {
                            HStack {
                                Image(systemName: "bookmark.fill")
                                    .font(.headline)
                                
                                Text("Save to History")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "4F46E5"), Color(hex: "7C3AED")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: Color(hex: "6366F1").opacity(0.4), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            
            // Saved confirmation toast
            if showSavedConfirmation {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.green)
                        
                        Text("Changes saved")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }
                    .padding()
                    .background(Color(hex: "1E293B").opacity(0.9))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet) {
            if let imageData = viewModel.editedFoodItem.imageData, let uiImage = UIImage(data: imageData) {
                ShareSheet(items: [uiImage, "Food: \(viewModel.editedFoodItem.name)\nCalories: \(Int(viewModel.editedNutritionInfo.calories)) kcal\nProtein: \(Int(viewModel.editedNutritionInfo.protein))g\nCarbs: \(Int(viewModel.editedNutritionInfo.carbohydrates))g\nFat: \(Int(viewModel.editedNutritionInfo.fat))g"])
            } else {
                ShareSheet(items: ["Food: \(viewModel.editedFoodItem.name)\nCalories: \(Int(viewModel.editedNutritionInfo.calories)) kcal\nProtein: \(Int(viewModel.editedNutritionInfo.protein))g\nCarbs: \(Int(viewModel.editedNutritionInfo.carbohydrates))g\nFat: \(Int(viewModel.editedNutritionInfo.fat))g"])
            }
        }
    }
}

// Share sheet for sharing results
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
