import UIKit
import Batch.Inbox

class InboxTableViewController: UITableViewController {
    
    var inboxAPI: BatchInboxFetcher!
    var firstRefresh = true
    var loading = true
    var userIdMode = false
    
    var notifications:[BatchInboxNotificationContent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 58.0
        tableView.rowHeight = UITableView.automaticDimension

        makeInboxFetcherInstance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (firstRefresh) {
            firstRefresh = false
            if let refreshControl = self.refreshControl {
                refreshControl.beginRefreshing()
                refreshControl.sendActions(for: .valueChanged)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let notifsCount = notifications.count
        
        if (loading || !inboxAPI.endReached) {
            return notifsCount + 1
        }
        return notifsCount
    }
    
    func reloadData() {
        notifications = inboxAPI.allFetchedNotifications
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        
        if indexPath.row < notifications.count {
            let notification = notifications[indexPath.row]
            
            let identifier: String
            if notification.attachmentURL == nil {
                identifier = "notificationCell"
            } else {
                identifier = "imageNotificationCell"
            }
            
            let notificationCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NotificationCell
            
            notificationCell?.update(notification: notification)
            
            cell = notificationCell
        } else if loading {
            cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
        } else if !inboxAPI.endReached {
            cell = tableView.dequeueReusableCell(withIdentifier: "loadMoreCell", for: indexPath)
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let item = notifications[indexPath.row]
        
        var actions: [UITableViewRowAction] = []
        
        if (item.isUnread) {
            let readAction = UITableViewRowAction(style: .normal, title: "Mark as read", handler: {[weak self] (_: UITableViewRowAction, path: IndexPath) in
                self?.inboxAPI?.markNotification(asRead: item)
                self?.tableView.setEditing(false, animated: true)
                self?.reloadData()
            })
            readAction.backgroundColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
            actions.append(readAction)
        }
        
        return actions
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == notifications.count {
            fetchMore()
        }
    }
    
    @IBAction func refreshTriggered(sender: Any) {
        // Recreate the inbox fetcher as the configuration might have changed
        inboxAPI.fetchNewNotifications { (err: Error?, notifications: [BatchInboxNotificationContent]?, _: Bool, _: Bool) in
            (sender as? UIRefreshControl)?.endRefreshing()
            self.loading = false
            print("Done: \(String(describing: err)) \(String(describing: notifications))")
            self.reloadData()
        }
    }
    
    @IBAction func markAllAsRead(_ sender: Any) {
        inboxAPI?.markAllNotificationsAsRead()
        self.reloadData()
    }
    
    fileprivate func makeInboxFetcherInstance() {
        inboxAPI = BatchInbox.fetcher()
    }
    
    func fetchMore() {
        if loading {
            return
        }
        loading = true
        inboxAPI.fetchNextPage { (error: Error?, notifications: [BatchInboxNotificationContent]?, _: Bool) in
            self.loading = false
            self.reloadData()
        }
    }
    
}
