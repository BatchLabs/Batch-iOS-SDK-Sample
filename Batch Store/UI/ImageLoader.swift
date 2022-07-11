import Foundation
import UIKit

class ImageLoader {
    
    private static var cache: [String: UIImage?] = [:]
    
    static func imageFor(article: Article) -> UIImage? {
        if let cachedImage = cache[article.name] {
            return cachedImage
        }
        
        let image = UIImage(named: article.image) ?? UIImage()
        cache[article.name] = image
        return image
    }
}
