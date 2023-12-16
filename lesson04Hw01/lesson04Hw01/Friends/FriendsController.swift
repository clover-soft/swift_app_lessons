import UIKit

class FriendsController: UITableViewController {
    private var data = [FriendsModel.Response.Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFriendsData()
    }
    
    private func setupTableView() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        title = "Друзья"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        tableView.register(FriendsViewCell.self, forCellReuseIdentifier: "FriendsViewCell")
        // Настройка Refresh Control
        refreshControl?.addTarget(self, action: #selector(refreshFriendData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshFriendData(_ sender: Any) {
        // Обновление данных
        loadFriendsData()
    }
    
    private func loadFriendsData() {
        APIManager.shared.getData(for: .friends) { [weak self] friends in
            guard let self = self, let friends = friends as? [FriendsModel.Response.Friend] else {
                self?.refreshControl?.endRefreshing() // Остановка анимации обновления в случае ошибки
                print("error friends")
                return
            }
            self.data = friends
            DispatchQueue.main.async {
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
        // Возвращаем ячейку с данными друга
        return cell
    }
}
