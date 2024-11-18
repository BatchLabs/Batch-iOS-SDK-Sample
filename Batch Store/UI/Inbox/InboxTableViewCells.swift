import Foundation
import UIKit
import Batch.Inbox
import SDWebImage

class NotificationCell : UITableViewCell {
    
    static let dateFormatter:DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm yyyy/MM/dd"
        return df
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var unreadView: UIView!
    
    func update(notification: BatchInboxNotificationContent) {
        titleLabel.text = notification.message?.title ?? "<No title>"
        contentLabel.text = notification.message?.body ?? "<No body>"
        unreadView.isHidden = !notification.isUnread
        dateLabel.text = NotificationCell.dateFormatter.string(from: notification.date)
    }
}

class ImageNotificationCell : NotificationCell {
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Task { @MainActor in
            attachmentImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
    }
    
    override func update(notification: BatchInboxNotificationContent) {
        super.update(notification: notification)
        
        if let attachment = notification.attachmentURL {
            attachmentImageView.sd_setImage(with: attachment)
        } else {
            attachmentImageView.image = UIImage()
        }
    }
}
