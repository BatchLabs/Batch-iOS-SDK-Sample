import Foundation
import UIKit

class ArticleDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var article: Article?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let article = article {
            imageView.image = ImageLoader.imageFor(article: article)
            nameLabel.text = article.name
            priceLabel.text = "\(article.price) €"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if article == nil {
            pop()
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        if let article = article {
            CartManager.add(article)
        }
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}
