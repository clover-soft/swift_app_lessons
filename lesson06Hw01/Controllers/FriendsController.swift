import UIKit

final class FriendsController: UITableViewController {
    private var data = [FriendsModel.Response.Friend]()
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Profile",
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        
        applyTheme(ThemeManager.shared.currentTheme)
        setupTableView()
        loadFriendsData()
    }
    
    private func setupTableView() {
        tableView.refreshControl = refresh
        title = "Друзья"
        tableView.register(FriendsViewCell.self, forCellReuseIdentifier: "FriendsViewCell")
        refresh.addTarget(self, action: #selector(loadFriendsData), for: .valueChanged)
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
    
    @objc func rightBarButtonTapped() {

        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.type = .reveal
        animation.subtype = .fromRight
        
        self.navigationController?.view.layer.add(animation, forKey: nil)
        
        navigationController?.pushViewController(ProfileController, animated: false)
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
