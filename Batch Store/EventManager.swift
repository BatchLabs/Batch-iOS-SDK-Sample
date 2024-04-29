import Foundation
import Batch.User

class EventManager {
    // This class only has class methods
    fileprivate init() {}
    
    // Track when the user starts playing an episode
    class func trackArticleVisit(_ article: Article) {
        BatchProfile.trackEvent(name: "ARTICLE_VIEW", attributes: BatchEventAttributes { attrs in
            attrs.put(article.name, forKey: "$label")
            attrs.put(article.name, forKey: "name")
        })
    }
    
    class func trackAddArticleToCart(_ article: Article) {
        BatchProfile.trackEvent(name: "ADD_TO_CART", attributes: BatchEventAttributes { attrs in
            attrs.put(article.name, forKey: "$label")
            attrs.put(article.name, forKey: "name")
        })
    }
    
    class func trackCheckout(_ amount: Double) {
        BatchProfile.trackEvent(name: "CHECKOUT", attributes: BatchEventAttributes { attrs in
            attrs.put(amount, forKey: "amount")
        })
    }
}
