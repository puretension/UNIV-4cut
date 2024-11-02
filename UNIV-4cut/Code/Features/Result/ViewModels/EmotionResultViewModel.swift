import SwiftUI

struct EmotionViewData: Hashable {
    var value: String
    var name: String
    var description: String
    var imageURL: String
}

final class EmotionResultViewModel: ObservableObject {
    @Published var pictureEmotionData: [EmotionViewData] = [
        EmotionViewData(
            value: "JOY",
            name: "기쁨",
            description: "행복, 만족, 감사함 등 긍정적인 감정으로 인해 기쁨을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/JOY.png"
        ),
        EmotionViewData(
            value: "ANTICIPATION",
            name: "기대",
            description: "앞으로 다가올 일에 대한 기대와 설렘, 혹은 불안감을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/ANTICIPATION.png"
        ),
        EmotionViewData(
            value: "LOVE",
            name: "사랑",
            description: "연인, 가족, 친구 등에 대한 사랑과 애정에서 오는 따뜻함을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/LOVE.png"
        ),
        EmotionViewData(
            value: "SURPRISE",
            name: "놀람",
            description: "예상치 못한 일로 인한 긍정적 또는 부정적 놀라움을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/SURPRISE.png"
        ),
        EmotionViewData(
            value: "FEAR",
            name: "두려움",
            description: "불안, 공포, 걱정 등 미래에 대한 불확실성을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/FEAR.png"
        ),
        EmotionViewData(
            value: "ANGER",
            name: "분노",
            description: "불의, 좌절감, 짜증 등으로 인해 강한 불쾌감을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/ANGER.png"
        ),
        EmotionViewData(
            value: "BOTHER",
            name: "무기력함",
            description: "지침, 피로, 의욕 상실 등을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/BOTHER.png"
        ),
        EmotionViewData(
            value: "GUILT",
            name: "죄책감",
            description: "잘못된 행동이나 말로 인해 스스로 후회와 자책을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/GUILT.png"
        ),
        EmotionViewData(
            value: "SADNESS",
            name: "슬픔",
            description: "상실, 좌절, 그리움 등으로 인해 우울한 감정을 느꼈어요.",
            imageURL: "https://operation.pickply.com/daily-emotions/SADNESS.png"
        )
    ]
    // 특정 감정만 랜덤으로 선택하여 중복 없이 반환
     func getRandomEmotions(count: Int = 4) -> [EmotionViewData] {
         let filteredEmotions = pictureEmotionData.filter {
             $0.value == "JOY" ||
             $0.value == "SURPRISE" ||
             $0.value == "SADNESS" ||
             $0.value == "BOTHER"
         }
         
         // 섞어서 상위 count개의 고유한 감정을 반환
         return filteredEmotions.shuffled().prefix(count).map { $0 }
     }
    
//    func getRandomEmotions(count: Int = 4) -> [EmotionViewData] {
//        return pictureEmotionData.shuffled().prefix(count).map { $0 }
//    }
    
    func getEmotionData(for emotion: String) -> EmotionViewData? {
        return pictureEmotionData.first { $0.value == emotion }
    }
}
