//
//  GroupController.swift
//  lesson04Hw01
//
//  Created by yakov on 15.12.2023.
//

import Foundation
//
//  GroupsController.swift
//  lesson02Hw01
//
//  Created by yakov on 27.11.2023.
//

import UIKit

class GroupsController: UITableViewController {
    private var data = [GroupsModel.Response.Group]()
    override func viewDidLoad() {        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        APIManager.shared.getData(for: .groups) { [weak self] groups in
            guard let groups = groups as? [GroupsModel.Response.Group] else {
                print("error groups")
                return
            }
            self?.data = groups
            DispatchQueue.main.async {
                print("reload data  groups")
                self?.tableView.reloadData()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        GroupsViewCell()
    }
}
