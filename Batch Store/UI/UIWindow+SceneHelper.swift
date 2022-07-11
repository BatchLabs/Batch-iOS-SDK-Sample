import Foundation
import UIKit

extension UIWindow {
    @available(iOS 13.0, *)
    static var keyWindowFromSceneAPI: UIWindow? {
        get {
            let connectedScenes = UIApplication.shared.connectedScenes
            for scene in connectedScenes {
                if let scene = scene as? UIWindowScene, scene.activationState == .foregroundActive {
                    for window in scene.windows {
                        if window.isKeyWindow {
                            return window
                        }
                    }
                }
            }
            return nil
        }
    }
}
