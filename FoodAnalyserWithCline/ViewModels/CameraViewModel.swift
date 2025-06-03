import SwiftUI
import Combine
import UIKit

class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var isAnalyzing = false
    @Published var analysisResult: AnalysisResult?
    @Published var showingResults = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let imageAnalysisService = ImageAnalysisService()
    
    func analyzeFood() {
        guard let image = capturedImage else { return }
        
        isAnalyzing = true
        
        imageAnalysisService.analyzeImage(image) { [weak self] result in
            guard let self = self else { return }
            
            self.isAnalyzing = false
            
            switch result {
            case .success(let analysisResult):
                self.analysisResult = analysisResult
                DataPersistenceService.shared.saveAnalyzedItem(analysisResult)
                self.showingResults = true
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showingError = true
            }
        }
    }
    
    func resetImage() {
        capturedImage = nil
        analysisResult = nil
    }
}
