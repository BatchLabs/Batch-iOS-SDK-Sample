import UIKit

class LoginCredentialsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the keyboard dismiss when we tap outside of a field
        let tapper = UITapGestureRecognizer(target: view, action:#selector(UIView.endEditing))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInAction(_ sender: AnyObject) {
        if let emailString = email.text , emailString.trimmingCharacters(in: CharacterSet.whitespaces) != "", let firstnameString = firstname.text , firstnameString.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
            
            let userManager = UserManager()
            if !userManager.isLoggedIn {
                userManager.login(firstName: firstnameString, username: emailString)
            } else {
                // Invalid state, ignore
            }
            
            if !PushManager().didTriggerSystemPopup {
                performSegue(withIdentifier: "enablePushSegue", sender: self)
            } else {
                dismiss()
            }
            
        } else {
            // Invalid email
            let alert = UIAlertController(title: "Invalid Login",
                                          message: "Please enter a valid first name and email",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func dismiss() {
        if self.tabBarController != nil {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            signInAction(textField)
        } else {
            return true
        }
        
        return false
    }
}
