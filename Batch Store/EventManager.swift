import Foundation
import Batch.User

class EventManager {
    // This class only has class methods
    fileprivate init() {}
    
    // Track when the user starts playing an episode
    class func trackArticleVisit(_ article: Article) {
        BatchUser.trackEvent("ARTICLE_VIEW", withLabel: article.name)
    }
    
    class func trackAddArticleToCart(_ article: Article) {
        BatchUser.trackEvent("ADD_TO_CART", withLabel: article.name)
    }
    
    class func trackCheckout(_ amount: Double) {
        BatchUser.trackEvent("CHECKOUT")
        BatchUser.trackTransaction(withAmount: amount)
    }
}
