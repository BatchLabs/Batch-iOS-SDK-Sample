import Foundation
import UIKit
import UserNotifications
import Batch.Push

private let systemPopupTriggeredKey = "systemPopupTriggered"

let singleArticleCategory = "article"

let saveActionIdentifier = "save"
let saveActionLabel = "Save for later"

let addCartActionIdentifier = "add_to_cart"
let addCartActionLabel = "Add to cart"

// Manages push notification registration status and options
class PushManager {
    
    // Track the system notification popup
    // Note that this isn't entirely accurate since we can't know if we already did it,
    // but we can only know if we asked it once for this install
    // Since iOS 10, there is a way to know this for sure. This code doesn't use it
    // for now, since it is asynchronous and changes the application flow significantly
    var didTriggerSystemPopup: Bool {
        get {
            return UserDefaults.standard.bool(forKey: systemPopupTriggeredKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: systemPopupTriggeredKey)
        }
    }

    func register() {
        
        UNUserNotificationCenter.current().setNotificationCategories(createActions())
        
        BatchPush.requestNotificationAuthorization()
        didTriggerSystemPopup = true
    }
    
    func createActions() -> Set<UNNotificationCategory> {
        
        let saveAction = UNNotificationAction(identifier: saveActionIdentifier, title: saveActionLabel, options: [])
        
        let addToCartAction = UNNotificationAction(identifier: addCartActionIdentifier, title: addCartActionLabel, options: [.foreground])
        
        let category = UNNotificationCategory(identifier: singleArticleCategory, actions: [saveAction, addToCartAction], intentIdentifiers: [], options: [])
        
        return [category]
    }
}
