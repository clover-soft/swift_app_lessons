//
//  TabBarController.swift
//  lesson02Hw01
//
//  Created by yakov on 27.11.2023.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let friendsController = FriendsController()
    private let groupsController = GroupsController()
    private let photosController = PhotosController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Прописываем табы
        friendsController.tabBarItem = UITabBarItem(
            title: "Друзья",
            image: UIImage(systemName: "person.2"),
            selectedImage: nil
        )
        groupsController.tabBarItem = UITabBarItem(
            title: "Сообщества",
            image: UIImage(systemName: "person.3"),
            selectedImage: nil
        )
        photosController.tabBarItem = UITabBarItem(
            title: "Фотографии",
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            selectedImage: nil
        )
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
        ], for: .normal)
        
        // Добавляем контроллеры в массив табов
        viewControllers = [friendsController, groupsController, photosController]

        // Установим текущий заголовок
        updateTitle(for: selectedViewController)

    }

    // Делегат для обновления заголовка
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      updateTitle(for: viewController)
    }
    // Функция для обновления заголовка
    private func updateTitle(for viewController: UIViewController?) {
      title = viewController?.tabBarItem.title
    }
    
}
