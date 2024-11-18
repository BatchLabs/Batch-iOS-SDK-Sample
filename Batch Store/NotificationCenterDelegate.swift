import Foundation
import UserNotifications
import Batch

class NotificationCenterDelegate: NSObject, @preconcurrency UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        BatchPush.handle(userNotificationCenter: center, willPresent: notification, willShowSystemForegroundAlert: true)
        
        return [.sound, .badge, .banner, .list]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        BatchPush.handle(userNotificationCenter: center, didReceive: response)
    }
    
    @MainActor func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let settingsNavVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "settingsNavigationController")
        // Try to find the best VC to display the settings on
        if let presenterVC = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController?.visibleViewController {
            presenterVC.present(settingsNavVC, animated: true, completion: nil)
        }
    }
}

// With thanks to https://stackoverflow.com/a/45473125/1169052
extension UIViewController {
    /// The visible view controller from a given view controller
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else if self is UIAlertController {
            return nil
        } else {
            return self
        }
    }
}
