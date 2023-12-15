//
//  FriendsController.swift
//  lesson02Hw01
//
//  Created by yakov on 27.11.2023.
//

import UIKit

class FriendsController: UITableViewController {
    private var data = [FriendsModel.Response.Friend]()
    override func viewDidLoad() {        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        title = "Друзья"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        
        
        APIManager.shared.getData(for: .friends) { [weak self] friends in
            guard let friends = friends as? [FriendsModel.Response.Friend] else {
                return
            }
            self?.data = friends
            DispatchQueue.main.async {
                print("reload data  friends")
                self?.tableView.reloadData()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        FriendsViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationItem.title = "Друзья"
    }
}
