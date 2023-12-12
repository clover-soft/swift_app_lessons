//
//  FriendsController.swift
//  lesson02Hw01
//
//  Created by yakov on 27.11.2023.
//

import UIKit

class FriendsController: UITableViewController {
    
    override func viewDidLoad() {        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        FriendsViewCell()
    }
}
