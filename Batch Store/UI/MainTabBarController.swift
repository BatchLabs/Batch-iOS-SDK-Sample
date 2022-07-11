import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var cartItem: UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartItem = tabBar.items?.first(where: { $0.tag == 1 })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.updateBadge), name: CartArticlesUpdatedNotificationName, object: nil)
        updateBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func updateBadge() {
        let count = CartManager.articles.count
        cartItem?.badgeValue = count == 0 ? nil : "\(count)"
    }
}
