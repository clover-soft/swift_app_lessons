import UIKit

final class GroupsController: UITableViewController {
    
    private var data = [GroupsModel.Response.Group]()
    private let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        applyTheme(ThemeManager.shared.currentTheme)
        setupTableView()
        loadGroupsData()
    }
    
    private func setupTableView() {
        tableView.register(GroupsViewCell.self, forCellReuseIdentifier: "GroupsViewCellIdentifier")
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(loadGroupsData), for: .valueChanged)
    }
    
    @objc private func loadGroupsData() {
        APIManager.shared.getData(for: .groups) { [weak self] groups in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing() // End the refreshing animation
            }
            
            guard let groups = groups as? [GroupsModel.Response.Group] else {
                print("error groups")
                return
            }
            
            self?.data = groups
            DispatchQueue.main.async {
                print("reload data groups")
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsViewCellIdentifier", for: indexPath) as? GroupsViewCell else {
            fatalError("Could not dequeue GroupsViewCell")
        }
        let group = data[indexPath.row]
        cell.configureWithGroup(group)

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
        tableView.reloadData() // рендерим ячейки для новой темы
        refresh.tintColor = theme.labelTextColor

    }

}
