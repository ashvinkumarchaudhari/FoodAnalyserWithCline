import SwiftUI
import AVFoundation
import UIKit

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var isCameraPresented = false
    @State private var isShowingUI = false
    @Environment(\.presentationMode) var presentationMode
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
    private let cornerRadius: CGFloat = 16
    private let shadowColor = Color.black.opacity(0.1)
    private let textPrimary = Color(hex: "1E293B")
    private let textSecondary = Color(hex: "64748B")
    private let cardBackground = Color.white
    
    var body: some View {
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
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(textPrimary)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(color: shadowColor, radius: 4, x: 0, y: 2)
                            )
                    }
                    
                    Spacer()
                    
                    Text("Food Scanner")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Empty view for balance
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding([.horizontal, .top])
                
                // Main content
                if let image = viewModel.capturedImage {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Image card
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(cornerRadius)
                                    .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
                                    .padding(.horizontal)
                                
                                // Reset button
                                if !viewModel.isAnalyzing {
                                    Button(action: viewModel.resetImage) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Circle().fill(Color.black.opacity(0.6)))
                                    }
                                    .padding([.top, .trailing], 25)
                                    .transition(.scale)
                                }
                            }
                            .padding(.top)
                            
                            // Analysis UI
                            VStack(spacing: 20) {
                                if viewModel.isAnalyzing {
                                    // Loading state
                                    VStack(spacing: 20) {
                                        ProgressView()
                                            .scaleEffect(1.5)
                                            .tint(Color(hex: "3B82F6"))
                                            .padding()
                                        
                                        Text("Analyzing your food...")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text("Identifying ingredients and calculating nutrition information")
                                            .font(.subheadline)
                                            .foregroundColor(textSecondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .fill(cardBackground)
                                            .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
                                    )
                                    .padding(.horizontal)
                                } else {
                                    // Action button
                                    Button(action: viewModel.analyzeFood) {
                                        HStack {
                                            Image(systemName: "sparkles")
                                                .font(.headline)
                                            
                                            Text("Analyze Food")
                                                .font(.headline)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(secondaryGradient)
                                        .foregroundColor(.white)
                                        .cornerRadius(cornerRadius)
                                        .shadow(color: Color(hex: "10B981").opacity(0.4), radius: 8, x: 0, y: 4)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                        .opacity(isShowingUI ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isShowingUI)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isShowingUI = true
                            }
                        }
                    }
                } else {
                    // Camera instruction screen
                    VStack(spacing: 25) {
                        Spacer()
                        
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 80))
                            .foregroundColor(Color(hex: "4F46E5"))
                            .opacity(0.9)
                        
                        VStack(spacing: 12) {
                            Text("Food Scanner")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Take a clear photo of your meal to analyze its nutritional content")
                                .font(.headline)
                                .foregroundColor(textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            isCameraPresented.toggle()
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.headline)
                                
                                Text("Take Photo")
                                    .font(.headline)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "4F46E5"), Color(hex: "7C3AED")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(cornerRadius)
                            .shadow(color: Color(hex: "3B82F6").opacity(0.4), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 32)
                        }
                        
                        Spacer()
                    }
                    .opacity(isShowingUI ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isShowingUI)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isShowingUI = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isCameraPresented) {
            ImagePicker(capturedImage: $viewModel.capturedImage)
        }
        .alert(isPresented: $viewModel.showingError) {
            Alert(
                title: Text("Analysis Error"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationDestination(isPresented: $viewModel.showingResults) {
            if let result = viewModel.analysisResult {
                ResultsView(analysisResult: result)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// Keep the ImagePicker as is
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
