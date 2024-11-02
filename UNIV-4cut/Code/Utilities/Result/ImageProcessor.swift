import UIKit

class ImageProcessor {
    // Merge base image with an emotion overlay
    func mergeImage(baseImage: UIImage, emotionImage: UIImage) -> UIImage? {
        let size = baseImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // Draw the base image
        baseImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Draw the emotion overlay on top
        let overlaySize = CGSize(width: size.width * 0.3, height: size.height * 0.3) // Adjust overlay size
        let overlayPosition = CGPoint(x: size.width - overlaySize.width - 10, y: 10) // Adjust overlay position
        emotionImage.draw(in: CGRect(origin: overlayPosition, size: overlaySize))
        
        // Get the final merged image
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mergedImage
    }
}
