import Foundation
import Batch.User

private let onboardingAttemptedKey = "onboardingAttempted"
private let firstNameKey = "accountFirstName"
private let usernameKey = "accountUsername"

class UserManager {
    var isLoggedIn: Bool {
        get {
            return username != nil
        }
    }
    
    var onboardingAttempted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: onboardingAttemptedKey)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: onboardingAttemptedKey)
        }
    }
    
    var firstName: String? {
        get {
            return UserDefaults.standard.string(forKey: firstNameKey)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: firstNameKey)
        }
    }
    
    var username: String? {
        get {
            return UserDefaults.standard.string(forKey: usernameKey)
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: usernameKey)
        }
    }
    
    func login(firstName: String, username: String) {
        self.firstName = firstName
        self.username = username
        syncBatchUserInfo()
    }
    
    func logout() {
        firstName = nil
        username = nil
    }
    
    func syncBatchUserInfo() {
        let username = self.username
        let editor = BatchUser.editor()
        if let firstName = self.firstName {
            try? editor.set(attribute: firstName, forKey: "firstname")
        } else {
            editor.removeAttribute(forKey: "firstname")
        }
        editor.setIdentifier(username)
        
        editor.save()
        
        SubscriptionManager().syncDataWithBatch()
    }
}
