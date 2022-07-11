import UIKit

class ArticleCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(_ article: Article) {
        name.text = article.name
        price.text = "\(article.price) €"
        image.image = ImageLoader.imageFor(article: article)
    }
}
