import Foundation

class ArticlesFakeDatasource {
    static let cache: [Article] = [
        Article(name: "Loafers", price: 280, image: "mocassins.png"),
        Article(name: "Sunglasses", price: 140, image: "aviators.png"),
        Article(name: "Black Handbag", price: 300, image: "sac_noir.png"),
        Article(name: "High Heels", price: 400, image: "chaussure_talon.png"),
        Article(name: "Necklace", price: 98, image: "collier.png"),
        Article(name: "Scarf", price: 110, image: "echarpe.png"),
        Article(name: "Patek Philippe", price: 27150, image: "patek_philippe.png"),
        Article(name: "Blouse", price: 260, image: "blouse.png"),
        Article(name: "Coat", price: 420, image: "manteau.png"),
        Article(name: "Submariner", price: 4200, image: "submariner.png"),
        Article(name: "Sneakers", price: 110, image: "basket.png"),
        Article(name: "Cap", price: 110, image: "casquette.png"),
    ]
    
    static var articles: [Article] {
        get {
            return cache
        }
    }
}



