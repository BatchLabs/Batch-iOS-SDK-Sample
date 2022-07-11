import Foundation
import UIKit

let systemAppearanceUserDefaultsKey = "system_appearance_override"

@available(iOS 13.0, *)
struct SystemAppearance {
    
    static func get() -> UIUserInterfaceStyle {
        UIUserInterfaceStyle.init(rawValue: UserDefaults.standard.integer(forKey: systemAppearanceUserDefaultsKey)) ?? UIUserInterfaceStyle.unspecified
    }
    
    static func set(_ appearance: UIUserInterfaceStyle) {
        UserDefaults.standard.set(appearance.rawValue, forKey: systemAppearanceUserDefaultsKey)
        if let keyWindow = UIWindow.keyWindowFromSceneAPI {
            apply(window: keyWindow)
        }
    }
    
    static func apply(window: UIWindow) {
        window.overrideUserInterfaceStyle = get()
    }
}
