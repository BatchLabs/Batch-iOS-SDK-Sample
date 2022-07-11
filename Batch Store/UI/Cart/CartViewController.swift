import Foundation
import UIKit

private let itemCellReuseIdentifier = "itemCell"

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    var articles = CartManager.articles
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellReuseIdentifier, for: indexPath)
        if let cell = cell as? CartCell {
            cell.update(articles[indexPath.row])
        }
        return cell
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        CartManager.checkout()
        refresh()
    }
    
    @IBAction func clearAction(_ sender: Any) {
        CartManager.clear()
        refresh()
    }
    
    func refresh() {
        articles = CartManager.articles
        priceLabel.text = "\(CartManager.computeTotal()) €"
        checkoutButton.isEnabled = articles.count > 0
        tableView.reloadData()
    }
}
