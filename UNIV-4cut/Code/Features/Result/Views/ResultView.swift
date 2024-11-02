import SwiftUI

//struct ResultView: View {
//    @StateObject private var viewModel = ResultViewModel()
//    let mergedImage: UIImage
//    
//    // 변수 리스트
//    // showingQRView : 큐알 화면
//    // showingHomeView : 홈 뷰
//    @State private var showingQRView = false
//    @State private var showingHomeView = false
//    @State private var selectedFrameIndex = 0
//    
//    // 프로세서
//    let processor = ImageProcessor()
//    
//    var body: some View {
//        VStack {
//            Spacer(minLength: 30)
//            GeometryReader { geometry in
//                ZStack {
//                    Image(uiImage: mergedImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .padding(.bottom, 180.0)
//                        .frame(width: geometry.size.width, height: geometry.size.height - 255)
//                        .navigationBarHidden(true)
//                    
//                    // 프레임 이미지 로딩
//                    if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
//                        Image(uiImage: frameImage)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: geometry.size.width, height: geometry.size.height - 200)
//                            .navigationBarHidden(true)
//                    } else {
//                        Text("프레임 이미지를 불러올 수 없습니다.")
//                            .foregroundColor(.red)
//                            .navigationBarHidden(true)
//                    }
//                }
//                
//                VStack(alignment: .center) {
//                    Spacer()
//                    
//                    FrameSelectionView(selectedFrameIndex: $selectedFrameIndex)
//                        .padding(.bottom, 30.0)
//                    
//                    ButtonActionView(
//                        viewModel: viewModel,
//                        showingHomeView: $showingHomeView,
//                        showingQRView: $showingQRView,
//                        mergedImage: mergedImage,
//                        selectedFrameIndex: selectedFrameIndex,
//                        processor: processor
//                    )
//                    .padding(.bottom, 20.0)
//                }
//            }
//            .padding(.all)
//            .edgesIgnoringSafeArea(.all)
//        }
//    }
//}

// ResultView에서 여러 이미지 중 하나를 선택하여 표시

struct ResultView: View {
    @StateObject private var viewModel = ResultViewModel()
    let mergedImages: [UIImage]
    @State private var showingQRView = false
    @State private var showingHomeView = false
    @State private var selectedFrameIndex = 0
    @State private var selectedEmotion: EmotionViewData? // Add selectedEmotion here
    let processor = ImageProcessor()
    
    var overlayImageName: String {
        // Determine the overlay image name based on the selected emotion
        switch selectedEmotion?.value {
        case "JOY":
            return "emotionCut_joy"
        case "SADNESS":
            return "emotionCut_sad"
        case "SURPRISE":
            return "emotionCut_surprise"
        default:
            return "emotionCut_just" // Default overlay
        }
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 30)
            GeometryReader { geometry in
                ZStack {
                    // Overlay frame image based on selected emotion
                    if let frameImage = UIImage(named: overlayImageName) {
                        Image(uiImage: frameImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width-5, height: geometry.size.height - 200)
                            .navigationBarHidden(true)
                    }

                    // Display the selected user image
                    if !mergedImages.isEmpty {
                        Image(uiImage: mergedImages[selectedFrameIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, 180.0)
                            .frame(width: geometry.size.width, height: geometry.size.height - 255)
                            .navigationBarHidden(true)
                    }
                }
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    // Thumbnail image selection at the bottom
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<mergedImages.count, id: \.self) { index in
                                Image(uiImage: mergedImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .border(index == selectedFrameIndex ? Color.blue : Color.clear, width: 2)
                                    .onTapGesture {
                                        selectedFrameIndex = index
                                    }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 100)
                    
                    ButtonActionView(
                        viewModel: viewModel,
                        emotionResultViewModel: EmotionResultViewModel(),
                        showingHomeView: $showingHomeView,
                        showingQRView: $showingQRView,
                        selectedEmotion: $selectedEmotion, mergedImage: mergedImages[selectedFrameIndex],
                        selectedFrameIndex: selectedFrameIndex,
                        processor: processor // Pass binding
                    )
                    .padding(.bottom, 20.0)
                }
            }
            .padding(.all)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
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

//import SwiftUI
//
//struct ResultView: View {
//    let mergedImage: UIImage  // 단일 UIImage로 수정
//
//    var body: some View {
//        VStack {
//            Spacer(minLength: 30)
//            
//            GeometryReader { geometry in
//                ZStack {
//                    // 단일 이미지 표시
//                    Image(uiImage: mergedImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .padding(.bottom, 180.0)
//                        .frame(width: geometry.size.width, height: geometry.size.height - 255)
//                        .navigationBarHidden(true)
//                }
//            }
//            .padding(.all)
//            .edgesIgnoringSafeArea(.all)
//        }
//    }
//}
//
//struct ImageSelectionView: View {
//    let capturedImages: [UIImage]
//    @Binding var selectedImage: UIImage?  // 선택한 이미지를 바인딩으로 전달
//
//    var body: some View {
//        HStack {
//            // 각 촬영된 이미지를 버튼으로 표시하여 선택할 수 있도록 합니다.
//            ForEach(0..<capturedImages.count, id: \.self) { index in
//                Button(action: {
//                    // 해당 이미지를 선택하여 `selectedImage`로 설정
//                    selectedImage = capturedImages[index]
//                }) {
//                    Image(uiImage: capturedImages[index])
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 70, height: 70)
//                        .border(Color.blue, width: selectedImage == capturedImages[index] ? 3 : 0)
//                }
//            }
//        }
//    }
//}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        if let exampleImage = UIImage(named: "4cut_example") {
//            ResultView(mergedImage: exampleImage)
//        } else {
//            ResultView(mergedImage: UIImage())
//        }
//    }
//}
