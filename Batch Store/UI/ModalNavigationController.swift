import Foundation
import UIKit

// A modal navigation controller that automatically adds a "Done" button to its shown view controllers
class ModalNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(sender:)))
        viewController.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneAction(sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
