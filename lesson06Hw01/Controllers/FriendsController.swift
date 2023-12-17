import UIKit

final class FriendsController: UITableViewController {
    private var data = [FriendsModel.Response.Friend]()
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
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
            guard let self = self, let friends = friends as? [FriendsModel.Response.Friend] else {
                self?.refreshControl?.endRefreshing() // Остановка анимации обновления в случае ошибки
                print("error friends")
                return
            }
            self.data = friends
            DispatchQueue.main.async {
                print("reload data friends")
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing() // Остановка анимации обновления
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

        let currentTheme = ThemeManager.shared.currentTheme
        cell.applyTheme(currentTheme)

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
        tableView.reloadData() // рендерим ячейки для новой темы
    }

}
