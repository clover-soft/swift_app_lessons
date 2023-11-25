//
//  NewViewController.swift
//  example02
//
//  Created by yakov on 24.11.2023.
//

import UIKit

class TableExample1ViewController: UIViewController, UITableViewDataSource {
    private var contacts: [String] = [
        "Евгений Иванов\n1234567890",
        "Елена Семеновна\n9876543210",
        "Михал Курков\n5555555555",
        "Дмитрий Ильин\n0123456789",
        "Данила Корн\n9999999999"
    ]
    
//    переопределение метода viewDidLoad() из класса UIViewController.
//
//    Метод viewDidLoad() вызывается, когда представление (view) контроллера загружается в память. Это происходит один раз, когда контроллер загружается из storyboard или когда его представление создается программно.
//
//    Переопределение метода viewDidLoad() позволяет вам добавить свой собственный код, который будет выполняться при загрузке представления контроллера. Вы можете использовать этот метод для настройки начального состояния вашего контроллера, инициализации данных, настройки пользовательского интерфейса и т.д.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        scrollView.addSubview(tableView)
        
        // Регистрируем ячейки а то схватим ошибку
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.reloadData()
        
        // Установим размер для прокрутки
        scrollView.contentSize = tableView.contentSize
    }
    
    // Раелизация с использованием UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = contacts[indexPath.row]
        return cell
    }
}
