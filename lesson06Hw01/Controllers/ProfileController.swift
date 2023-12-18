import UIKit

final class ProfileController: UIViewController, ProfileTabViewDelegate {
    private let profileTabView = ProfileTabView()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        applyTheme(ThemeManager.shared.currentTheme)

        setupProfileTabView()
        loadUserProfile()
    }
    
    private func setupProfileTabView() {
        title = "Профиль"
        transitioningDelegate = (tabBarController as? TabBarController)
        view.addSubview(profileTabView)
        profileTabView.frame = view.bounds
        profileTabView.delegate = self
    }
    
    private func loadUserProfile() {
        APIManager.shared.getData(for: .profile) { [weak self] result in
            DispatchQueue.main.async {
                if let userData = result as? [UserModel.User], let user = userData.first {
                    self?.profileTabView.configure(with: user)
                } else {
                    // Consider adding user-facing error handling here
                }
            }
        }
    }

    func didChangeTheme(to theme: Theme) {
        ThemeManager.shared.setTheme(theme)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let newTheme = notification.object as? Theme else { return }
        applyTheme(newTheme)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func applyTheme(_ theme: Theme) {
        profileTabView.currentTheme = theme
        profileTabView.updateThemeSelection(to: theme)
        view.backgroundColor = theme.backgroundColor
        profileTabView.backgroundColor = theme.backgroundColor
        profileTabView.nameLabel.textColor = theme.labelTextColor
        profileTabView.imageView.backgroundColor = theme.cellBackgroundColor
        profileTabView.themePicker.reloadAllComponents()
        let textAttributes = [NSAttributedString.Key.foregroundColor: theme.labelTextColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}
