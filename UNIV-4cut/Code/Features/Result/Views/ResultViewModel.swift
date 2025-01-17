import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreImage.CIFilterBuiltins
import UIKit
import Photos



class ResultViewModel: ObservableObject {
    @Published var isFirst = true
    @Published var qrCodeImage: UIImage? = nil // QR 코드 이미지

    let context = CIContext()
     let filter = CIFilter.qrCodeGenerator()
     
     func reset() {
         isFirst = true
         qrCodeImage = nil
     }

    
    // 다시 찍기를 누르면 isFrist를 False로 바꿈
    func retakeProcess() {
        // False
        isFirst = false
    }
    
    // 이미지 합치기
    func mergeImage(image: UIImage) -> UIImage? {
        isFirst = true
            // 프레임 이미지 로드
            guard let frameImage = UIImage(named: "4cut_frame") else {
                print("프레임 이미지를 불러올 수 없습니다.")
                return nil
            }
            
            // 원본 이미지와 프레임 이미지의 크기를 기반으로 새로운 이미지 크기 결정
            let newSize = CGSize(width: frameImage.size.width, height: frameImage.size.height)
            
            // 그래픽 컨텍스트 생성
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            
            // 원본 이미지 그리기
            let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            image.draw(in: imageRect)
            
            // 프레임 이미지 그리기
            let frameRect = CGRect(x:0, y: 0, width: frameImage.size.width, height: frameImage.size.height)
            frameImage.draw(in: frameRect)
            
            // 합쳐진 이미지 생성
            let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // 그래픽 컨텍스트 종료
            UIGraphicsEndImageContext()
            
            return mergedImage
        }
    
        // 이미지를 Firestore에 저장하고, 이미지 링크를 기반으로 QR 코드 생성
       func uploadImageAndGenerateQRCode(image: UIImage) {
           // 이미지를 Firebase Storage에 업로드
           let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
           guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
           
           storageRef.putData(imageData, metadata: nil) { (metadata, error) in
               guard error == nil else {
                   print("Failed to upload image to Firebase Storage")
                   return
               }
               
               // 업로드된 이미지의 URL 가져오기
               storageRef.downloadURL { (url, error) in
                   guard let downloadURL = url else {
                       print("Failed to get download URL")
                       return
                   }
                   // QR 코드 생성
                   self.generateQRCode2(from: downloadURL.absoluteString)
               }
           }
       }
    
    // QR만들기 두번째 방법
    func generateQRCode2(from string: String) -> UIImage{
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage{
            if let cgImage = context.createCGImage(outputImage, from : outputImage.extent)
            {
                self.qrCodeImage = UIImage(cgImage: cgImage)
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
    
    // 이미지 앨범에 저장
    func saveImageToAlbum(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion(false, NSError(domain: "PhotoLibraryAccessDenied", code: 1, userInfo: nil))
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        }
    }
}
