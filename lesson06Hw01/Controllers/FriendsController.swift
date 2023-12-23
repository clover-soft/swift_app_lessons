import UIKit

final class FriendsController: UITableViewController {
    private var data = [FriendsModel.Response.Friend]()
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Профиль",
            style: .plain,
            target: self,
            action: #selector(showProfile)
        )
        
        applyTheme(ThemeManager.shared.currentTheme)
        setupTableView()
        loadFriendsData()
    }
    
    
    @objc private func loadFriendsData() {
        APIManager.shared.getData(for: .friends) { [weak self] friends in
            DispatchQueue.main.async {
                guard let strongSelf = self, let friends = friends as? [FriendsModel.Response.Friend] else {
                    self?.refresh.endRefreshing()
                    return
                }
                strongSelf.data = friends
                strongSelf.tableView.reloadData()
                strongSelf.refresh.endRefreshing()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsViewCell", for: indexPath) as? FriendsViewCell else {
            return UITableViewCell()
        }
        cell.configureWithFriend(data[indexPath.row])
        cell.applyTheme(ThemeManager.shared.currentTheme)
        return cell
    }
    
    @objc private func themeDidChange(_ notification: Notification) {
        guard let newTheme = notification.object as? Theme else { return }
        applyTheme(newTheme)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        let textAttributes = [NSAttributedString.Key.foregroundColor: theme.labelTextColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        refresh.tintColor = theme.labelTextColor
        tableView.reloadData()
    }
}
