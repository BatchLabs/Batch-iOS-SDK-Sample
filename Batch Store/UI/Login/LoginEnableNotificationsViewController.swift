import UIKit
import Batch

class LoginEnableNotificationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        BatchPush.requestProvisionalNotificationAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func allowAction(_ sender: AnyObject) {
        PushManager().register()
        dismiss()
    }

    @IBAction func laterAction(_ sender: AnyObject) {
        dismiss()
    }
    
    func dismiss() {
        if self.tabBarController != nil {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
