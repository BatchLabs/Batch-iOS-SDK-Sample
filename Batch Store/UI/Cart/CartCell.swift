import Foundation
import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    func update(_ article: Article) {
        articleImageView.image = ImageLoader.imageFor(article: article)
        nameLabel.text = article.name
        priceLabel.text = "\(article.price) €"
    }
}
