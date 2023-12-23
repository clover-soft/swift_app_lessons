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
        view.backgroundColor = .white
        tableView.refreshControl = refresh
        tableView.backgroundColor = .white
        title = "Друзья"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        tableView.register(FriendsViewCell.self, forCellReuseIdentifier: "FriendsViewCell")
        refresh.addTarget(self, action: #selector(loadFriendsData), for: .valueChanged)

    }
    
    @objc private func loadFriendsData() {
        APIManager.shared.getData(for: .friends) { [weak self] (result: Result<FriendsModel, Error>) in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing()
                switch result {
                case .success(let friendsModel):
                    let friends = friendsModel.response.items
                    self?.data = friends
                    self?.tableView.reloadData()
                    CoreDataManager.shared.saveFriends(friends)
                case .failure(let error):
                    self?.showErrorAlert(error)
                }
            }
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        let message = "Не удалось обновить данные. Последние актуальные данные на \(CoreDataManager.shared.fetchFriendsLastUpdate()). Ошибка: \(error.localizedDescription)"
      let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
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
