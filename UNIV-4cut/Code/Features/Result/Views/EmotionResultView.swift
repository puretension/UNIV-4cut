import SwiftUI
import Kingfisher

struct EmotionResultView: View {
    @ObservedObject var viewModel: EmotionResultViewModel
    var emotion: EmotionViewData

    var body: some View {
        VStack(spacing: 20) {
            Text("당신의 사진을 감정으로 표현했어요")
                .font(.headline)
                .padding(.top, 20)
            
            Text(emotion.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            KFImage(URL(string: emotion.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            
            Text(emotion.description)
                .font(.body)
                .padding()
        }
        .padding()
        .navigationTitle("Emotion Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

