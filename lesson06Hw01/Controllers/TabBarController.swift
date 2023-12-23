import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    
    private let friendsController = FriendsController()
    private let groupsController = GroupsController()
    private let photosController = PhotosController()
    private let profileController = ProfileController()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        applyTheme(ThemeManager.shared.currentTheme)

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
        profileController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: nil
        )
        
        // Добавляем контроллеры в массив табов
        viewControllers = [friendsController, groupsController, photosController, profileController]

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
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is ProfileController {
            return ProfileTransitionAnimator()
        }
        return nil
    }
    // MARK: - Логика применения темы
    @objc private func themeDidChange(_ notification: Notification) {
        guard let newTheme = notification.object as? Theme else { return }
        applyTheme(newTheme)
    }

    private func applyTheme(_ theme: Theme) {
        // Применяем атрибуты шрифта и цвета к заголовкам вкладок
        UITabBarItem.appearance().setTitleTextAttributes(theme.tabBarTitleAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(theme.tabBarTitleAttributes, for: .selected)

        // Изменяем фоновый цвет tabBar
        tabBar.barTintColor = theme.backgroundColor
        tabBar.isTranslucent = false

        // Обновляем внешний вид, если вкладки уже отображаются
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes(theme.tabBarTitleAttributes, for: .normal)
                item.setTitleTextAttributes(theme.tabBarTitleAttributes, for: .selected)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
