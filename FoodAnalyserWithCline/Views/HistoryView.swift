// filepath: /Users/spaculus/Documents/FoodAnalyser/FoodAnalyser/Views/HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @State private var analyzedItems: [AnalysisResult] = []
    @State private var selectedDate: Date = Date()
    @State private var showCalendar = false
    @State private var isShowingUI = false
    
    // Match MainView styling
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "121212"), Color(hex: "1E1E1E")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    private let accentColor1 = Color(hex: "4F46E5") // Indigo
    private let accentColor2 = Color(hex: "7C3AED") // Violet
    
    var body: some View {
        NavigationView {
            ZStack {
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
                
                VStack(spacing: 0) {
                    // App header - styled like MainView
                    HStack {
                        // Left side empty for balance
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 44, height: 44)
                        
                        Spacer()
                        
                        Text("Food History")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Edit button on right side
                        EditButton()
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    .padding([.horizontal, .top])
                    
                    // Date selector with glass-morphic style
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showCalendar.toggle()
                                }
                            }) {
                                HStack {
                                    Text(formattedDate(selectedDate))
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    Image(systemName: "calendar")
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.ultraThinMaterial)
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(LinearGradient(
                                                    gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing),
                                                    lineWidth: 1)
                                        )
                                )
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Button(action: previousDay) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                                .opacity(0.7)
                                        )
                                }
                                
                                Button(action: nextDay) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                                .opacity(0.7)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        if showCalendar {
                            // Calendar with glass-morphic style
                            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                        .opacity(0.8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(LinearGradient(
                                                    gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing),
                                                    lineWidth: 1.5)
                                        )
                                )
                                .padding(.horizontal)
                                .onChange(of: selectedDate) { oldValue, newValue in
                                    showCalendar = false
                                    filterItemsByDate()
                                }
                        }
                        
                        // List of analyzed items for the selected date
                        if filteredItems.isEmpty {
                            Spacer()
                            VStack(spacing: 20) {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.bottom, 8)
                                
                                Text("No food analyzed on this date")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Button(action: {
                                    selectedDate = Date()
                                    filterItemsByDate()
                                }) {
                                    Text("Show today's items")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [accentColor1, accentColor2]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                        )
                                }
                            }
                            .padding(.top, 50)
                            Spacer()
                        } else {
                            // Custom list with glass-morphic styling
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(filteredItems) { result in
                                        NavigationLink(destination: ResultsView(analysisResult: result)) {
                                            HistoryItemCard(result: result)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .onDelete(perform: deleteItem)
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 10)
                        }
                    }
                    .opacity(isShowingUI ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isShowingUI)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                loadHistory()
                
                // Fade in UI like MainView
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isShowingUI = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var filteredItems: [AnalysisResult] {
        return HistoryViewModel.generateDummyData()
        // Uncomment the below code when using real data
        /*
        return analyzedItems.filter {
            Calendar.current.isDate($0.analysisDate, inSameDayAs: selectedDate)
        }
        .sorted(by: { $0.analysisDate > $1.analysisDate })
        */
    }
    
    private func filterItemsByDate() {
        // No filtering needed here since we use a computed property
    }
    
    private func loadHistory() {
        analyzedItems = DataPersistenceService.shared.loadAnalyzedItems()
    }
    
    private func deleteItem(at offsets: IndexSet) {
        // Get the items to delete from the filtered list
        let itemsToDelete = offsets.map { filteredItems[$0] }
        
        // Delete each item from the persistence layer
        for item in itemsToDelete {
            DataPersistenceService.shared.deleteAnalyzedItem(withId: item.id)
        }
        
        // Reload the history
        loadHistory()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func previousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

// Glass-morphic card for history items
struct HistoryItemCard: View {
    let result: AnalysisResult
    
    var body: some View {
        ZStack {
            // Glass-morphic background with border
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .opacity(0.7)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing),
                            lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            
            HStack {
                // Food image
                if let imageData = result.foodItem.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(result.foodItem.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(result.nutritionInfo.calories, specifier: "%.0f") calories")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(formattedTime(result.analysisDate))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.leading, 8)
                
                Spacer()
                
                // Macro nutrients
                VStack(alignment: .trailing, spacing: 4) {
                    MacroNutrientLabel(label: "Protein", value: result.nutritionInfo.protein)
                    MacroNutrientLabel(label: "Carbs", value: result.nutritionInfo.carbohydrates)
                    MacroNutrientLabel(label: "Fat", value: result.nutritionInfo.fat)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Component for macro nutrient labels
struct MacroNutrientLabel: View {
    let label: String
    let value: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            
            Text("\(value, specifier: "%.1f")g")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
