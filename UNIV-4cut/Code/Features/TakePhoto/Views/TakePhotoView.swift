import SwiftUI



//// 예제용 ButtonActionView
//struct ButtonActionView: View {
//    var viewModel: ResultViewModel
//    @Binding var showingHomeView: Bool
//    @Binding var showingQRView: Bool
//    var mergedImage: UIImage
//    var selectedFrameIndex: Int
//    var processor: ImageProcessor
//    
//    var body: some View {
//        Button("작업 실행") {
//            // 여기에 버튼 작업을 추가하세요
//        }
//    }
//}

struct TakePhotoView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    @State private var isPresentingResultView = false
    let processor = ImageProcessor()
    
    var body: some View {
        ZStack {
            CustomCameraView(viewModel: cameraViewModel)
            
            VStack {
                if cameraViewModel.remainingTime > 0 {
                    VStack {
                        Text("남은 시간")
                            .font(.custom("Pretendard-SemiBold", size: 40))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                        Text("\(cameraViewModel.remainingTime)")
                            .font(.custom("Pretendard-SemiBold", size: 100))
                            .foregroundColor(.black)
                    }
                } else {
                    Text("📸")
                        .font(.title)
                        .padding()
                }
                
                Spacer()
                
                Text("\(cameraViewModel.capturedImages.count)/4")
                    .foregroundColor(.white)
                    .font(.custom("Pretendard-SemiBold", size: 30))
                    .padding()
                    .padding(.horizontal, 17)
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(36)
                    .padding(.bottom, 40)
            }
            .foregroundColor(.white)
        }
        .onAppear {
            cameraViewModel.startCapturing()
        }
        .fullScreenCover(isPresented: $isPresentingResultView) {
            if cameraViewModel.capturedImages.count == 4 {
                // Apply emotion overlay to each captured image
                let emotionOverlay = UIImage(named: "emotion_joy") ?? UIImage()
                let mergedImages = cameraViewModel.capturedImages.compactMap {
                    processor.mergeImage(baseImage: $0, emotionImage: emotionOverlay)
                }
                ResultView(mergedImages: mergedImages) // Display merged images in ResultView
            }
        }
        .onChange(of: cameraViewModel.capturedImages) { newValue in
            isPresentingResultView = newValue.count == 4
        }
    }
}


// SwiftUI 미리보기
struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
