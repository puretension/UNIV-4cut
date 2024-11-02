import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var capturedImages: [UIImage] = []
    @Published var remainingTime = 0
    @Published var mergedImage: UIImage? = nil
    @Published var count = 0
    @Published var isCapturingComplete = false  // 추가: 촬영 완료 상태

    var captureAction: (() -> Void)?
    var timer: Timer?
    var captureCount = 0

    func startCapturing() {
        timer?.invalidate()
        captureCount = 0
        capturedImages.removeAll()
        remainingTime = 1
        isCapturingComplete = false  // 촬영 시작시 false로 설정
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            if captureCount < 4 {
                captureAction?()
                remainingTime = 1
            } else {
                // 타이머 종료
                timer?.invalidate()
                timer = nil
                count += 1
                
                // 이미지 병합 및 상태 업데이트
                mergedImage = mergeImages()
                isCapturingComplete = true  // 촬영 완료 상태로 변경
                
                // 타이머 관련 상태만 초기화
                resetTimerState()
            }
        }
    }
    
    // 타이머 관련 상태만 초기화하는 함수
    private func resetTimerState() {
        remainingTime = 0
        captureCount = 0
    }
    
    // 전체 상태 초기화는 필요할 때만 명시적으로 호출
    func resetAllState() {
        capturedImages = []
        remainingTime = 0
        captureCount = 0
        mergedImage = nil
        isCapturingComplete = false
    }

    func mergeImages() -> UIImage? {
        guard capturedImages.count == 4 else {
            print("Captured images count does not match expected. Found: \(capturedImages.count)")
            return nil
        }
        
        let flippedImages = capturedImages.map { $0.withHorizontallyFlippedOrientation() ?? $0 }
        
        let resizeWidth = capturedImages[0].size.width / 2
        let resizeHeight = capturedImages[0].size.height / 2
        let size = CGSize(width: resizeWidth * 2, height: resizeHeight * 2)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        for (index, image) in capturedImages.enumerated() {
            guard let resizedImage = image.resized(toWidth: resizeWidth) else {
                print("Failed to resize image at index \(index).")
                UIGraphicsEndImageContext()
                return nil
            }
            let x = CGFloat(index % 2) * resizeWidth
            let y = CGFloat(index / 2) * resizeHeight
            resizedImage.draw(in: CGRect(x: x, y: y, width: resizeWidth, height: resizeHeight))
        }
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let merged = mergedImage {
            print("Image merging successful.")
            return merged
        } else {
            print("Failed to merge images.")
            return nil
        }
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
