import UIKit
import Batch

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var enablePush: UISwitch!
    @IBOutlet weak var flashSales: UISwitch!
    @IBOutlet weak var suggestedContent: UISwitch!
    
    @IBOutlet weak var suggestionFashion: UISwitch!
    @IBOutlet weak var suggestionMensWear: UISwitch!
    @IBOutlet weak var suggestionOther: UISwitch!
    
    @IBOutlet var notificationSwitches: [UISwitch]!
    
    @IBOutlet weak var themeValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshForm()
        refreshTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Refresh the notification settings when we come back in the app, since the user can have changed them in iOS' settings
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForm), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Also refresh the notification settings when iOS tells us they changed, since DidBecomeActiveNotification arrives a little too early
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForm), name: NSNotification.Name.BatchPushUserDidAnswerAuthorizationRequest, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 0) {
            if let username = UserManager().username {
                return "Logged in as \(username)"
            }
        }
        
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            // Login button
            let userManager = UserManager()
            if userManager.isLoggedIn {
                userManager.logout()
                refreshForm()
            } else {
                performSegue(withIdentifier: "loginSegue", sender: self)
            }
        } else if indexPath.section == 3 && indexPath.row == 1 {
            // Theme button
            showThemeSelector(sourceRect: tableView.rectForRow(at: indexPath))
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refreshForm() {
        let loggedIn = UserManager().isLoggedIn
        let subscriptionManager = SubscriptionManager()
        
        // Enable all switches by default
        notificationSwitches.forEach({ (notifSwitch) in
            notifSwitch.isEnabled = true
        })
        
        // Logged out users can't get notifications about new episodes
        if !loggedIn {
            flashSales.isOn = false
            flashSales.isEnabled = false
        } else {
            flashSales.isOn = subscriptionManager.flashSales
            flashSales.isEnabled = true
        }
        
        let suggestedContentEnabled = subscriptionManager.suggestedContent
        
        suggestedContent.isOn = suggestedContentEnabled
        suggestionFashion.isOn = subscriptionManager.isSubscribedToSuggestion(suggestionCategoryFashion)
        suggestionMensWear.isOn = subscriptionManager.isSubscribedToSuggestion(suggestionCategoryMensWear)
        suggestionOther.isOn = subscriptionManager.isSubscribedToSuggestion(suggestionCategoryOther)
        
        if !suggestedContentEnabled {
            suggestionFashion.isEnabled = false
            suggestionMensWear.isEnabled = false
            suggestionOther.isEnabled = false
        }
        
        // Set the "enable push notifications" switch value according to the system settings
        // It is a special toggle
        if let notifSettings = UIApplication.shared.currentUserNotificationSettings {
            enablePush.isOn = notifSettings.types.rawValue != 0
        } else {
            enablePush.isOn = false
        }
        
        // If push is not enabled, force disable every other switch
        if !enablePush.isOn {
            notificationSwitches.filter {$0 != enablePush}.forEach({ (notifSwitch) in
                notifSwitch.isEnabled = false
            })
        }
        
        let oldLoginLabel = loginButton.currentTitle
        
        if loggedIn {
            loginButton.setTitle("Log out", for: UIControl.State())
        } else {
            loginButton.setTitle("Log in", for: UIControl.State())
        }
        
        // If the button label changed, we want to update the "Logged in as xxx" section header
        if oldLoginLabel != loginButton.currentTitle {
            tableView.reloadData()
        }

    }
    
    func refreshTheme() {
        let theme = SystemAppearance.get()
        themeValue.text = {
            switch theme {
            case .unspecified:
                return "Default"
            case .light:
                return "Light"
            case .dark:
                return "Dark"
            @unknown default:
                return "Unknown"
            }
        }()
    }
    
    @IBAction func enablePushToggled(_ sender: AnyObject) {
        // If we're sure we never asked for the OS settings, show the notification optin modal
        if !PushManager().didTriggerSystemPopup {
            self.enablePush.setOn(!self.enablePush.isOn, animated: true)
            
            performSegue(withIdentifier: "enablePushSegue", sender: self)
            
            return
        }
        
        // Tell the user that we will redirect him to iOS settings
        // This assumes that he already has been asked to get notifications
        
        let alert = UIAlertController(title: "Toggle push notifications",
                                      message: "In order to change the global notification settings, you'll be redirected to iOS' settings.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go", style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.enablePush.setOn(!self.enablePush.isOn, animated: true)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func flashSalesToggled(_ sender: AnyObject) {
        SubscriptionManager().flashSales = flashSales.isOn
        refreshForm()
    }
    
    @IBAction func suggestedContentToggled(_ sender: AnyObject) {
        SubscriptionManager().suggestedContent = suggestedContent.isOn
        refreshForm()
    }
    
    @IBAction func suggestionCategoryToggled(_ sender: AnyObject) {
        if let sender = sender as? UISwitch {
            var topicName: String?
            
            switch sender {
            case suggestionFashion:
                topicName = suggestionCategoryFashion
                break
            case suggestionMensWear:
                topicName = suggestionCategoryMensWear
                break
            case suggestionOther:
                topicName = suggestionCategoryOther
                break
            default:
                // Do nothing
                break
            }
            
            if let topicName = topicName {
                SubscriptionManager().toggleSuggestionCategory(topicName, enabled: sender.isOn)
            }
        }
    }
    
    func showThemeSelector(sourceRect: CGRect) {
        let picker = UIAlertController(title: "Select an interface style", message: nil, preferredStyle: .actionSheet)
        picker.addAction(UIAlertAction(title: "Default", style: .default) {_ in self.setTheme(.unspecified) })
        picker.addAction(UIAlertAction(title: "Light", style: .default) {_ in self.setTheme(.light) })
        picker.addAction(UIAlertAction(title: "Dark", style: .default) {_ in self.setTheme(.dark) })
        
        if let popoverController = picker.popoverPresentationController {
            popoverController.sourceView = self.tableView
            popoverController.sourceRect = sourceRect
          }
        
        present(picker, animated: true, completion: nil)
    }
    
    @available(iOS 13.0, *)
    func setTheme(_ theme: UIUserInterfaceStyle) {
        SystemAppearance.set(theme)
        refreshTheme()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
