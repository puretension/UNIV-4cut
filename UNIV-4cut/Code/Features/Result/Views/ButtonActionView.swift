import SwiftUI

struct ButtonActionView: View {
    @ObservedObject var viewModel: ResultViewModel
    @ObservedObject var emotionResultViewModel: EmotionResultViewModel
    @Binding var showingHomeView: Bool
    @Binding var showingQRView: Bool
    @Binding var selectedEmotion: EmotionViewData? // Change to Binding

    @State private var showingEmotionView = false
    let mergedImage: UIImage
    let selectedFrameIndex: Int
    let processor: ImageProcessor

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ReusableButton(title: "홈", boxWidth: 90) {
                viewModel.reset()
                showingHomeView = true
            }
            .fullScreenCover(isPresented: $showingHomeView) {
                HomeView()
            }

            ReusableButton(title: "QR 코드", boxWidth: 90) {
                showingQRView = true
                generateQRCode()
            }
            .sheet(isPresented: $showingQRView) {
                QRCodeSheetView(viewModel: viewModel, showingHomeView: $showingHomeView, showingQRView: $showingQRView)
            }

            ReusableButton(title: "앨범 저장", boxWidth: 90) {
                saveImgInGallery()
            }

            ReusableButton(title: "감정 보기", boxWidth: 90) {
                selectedEmotion = emotionResultViewModel.getRandomEmotions(count: 1).first
                showingEmotionView = true
            }
            .sheet(isPresented: $showingEmotionView) {
                if let emotion = selectedEmotion {
                    EmotionResultView(viewModel: emotionResultViewModel, emotion: emotion)
                } else {
                    Text("감정 데이터를 불러올 수 없습니다.")
                }
            }
            Spacer()
        }
    }


    private func generateQRCode() {
//        if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
//            if let frameMergedImage = processor.mergeImage(image: mergedImage, frameImage: frameImage) {
//                viewModel.uploadImageAndGenerateQRCode(image: frameMergedImage)
//            } else {
//                print("이미지 합치기에 실패했습니다.")
//            }
//        }
    }

    private func saveImgInGallery() {
//        if let frameImage = UIImage(named: "4cut_\(selectedFrameIndex + 1)") {
//            if let frameMergedImage = processor.mergeImage(image: mergedImage, frameImage: frameImage) {
//                viewModel.saveImageToAlbum(image: frameMergedImage) { success, error in
//                    if success {
//                        alertTitle = "저장 완료"
//                        alertMessage = "이미지가 성공적으로 저장되었습니다."
//                    } else if let error = error {
//                        alertTitle = "저장 실패"
//                    }
//                    showingAlert = true
//                }
//            } else {
//                alertTitle = "저장 실패"
//                alertMessage = "이미지 합치기에 실패했습니다."
//                showingAlert = true
//            }
//        } else {
//            alertTitle = "저장 실패"
//            alertMessage = "프레임 이미지를 불러올 수 없습니다."
//            showingAlert = true
//        }
    }
}
