import Foundation

let CartArticlesUpdatedNotificationName = NSNotification.Name(rawValue: "CartArticlesUpdatedNotification")

class CartManager {
    static var articles: [Article] = []
    
    static func add(_ article: Article) {
        articles.append(article)
        EventManager.trackAddArticleToCart(article)
        NotificationCenter.default.post(name: CartArticlesUpdatedNotificationName, object: nil)
    }
    
    static func clear() {
        articles.removeAll()
        NotificationCenter.default.post(name: CartArticlesUpdatedNotificationName, object: nil)
    }
    
    static func computeTotal() -> Int {
        return articles.map{$0.price}.reduce(0, +)
    }
    
    static func checkout() {
        EventManager.trackCheckout(Double(computeTotal()))
        clear()
    }
}
