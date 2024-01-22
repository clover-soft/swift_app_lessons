import UIKit

final class GroupsController: UITableViewController {
  
  private struct Constants {
    static let cellIdentifier = "GroupsViewCellIdentifier"
  }
  
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
    tableView.register(GroupsViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    tableView.refreshControl = refresh
    refresh.addTarget(self, action: #selector(loadGroupsData), for: .valueChanged)
  }
  


    @objc private func loadGroupsData() {
        APIManager.shared.getData(for: .groups) { [weak self] (result: Result<GroupsModel, Error>) in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing()
                switch result {
                case .success(let groupsModel):
                    let groups = groupsModel.response.items
                    self?.data = groups
                    self?.tableView.reloadData()
                    CoreDataManager.shared.saveGroups(groups)
                case .failure(let error):
                    self?.data = CoreDataManager.shared.fetchGroups()
                    self?.showErrorAlert(error)
                }
            }
        }
    }

    private func showErrorAlert(_ error: Error) {
        let message = "Не удалось обновить данные. Последние актуальные данные на \(CoreDataManager.shared.fetchGroupsLastUpdate()). Ошибка: \(error.localizedDescription)"
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? GroupsViewCell else {
      fatalError("Could not dequeue GroupsViewCell")
    }
    let group = data[indexPath.row]
    cell.configureWithGroup(group)
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
    tableView.reloadData()
    refresh.tintColor = theme.labelTextColor
  }
}
