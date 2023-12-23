import UIKit

final class PhotosController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var data = [PhotosModel.Response.Photo]()
    private let reuseIdentifier = "PhotoCell"
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let itemsPerRow: CGFloat = 2
    private let refresh = UIRefreshControl()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        // Установка интервалов между элементами и линиями секций
        layout.minimumInteritemSpacing = sectionInsets.left
        layout.minimumLineSpacing = sectionInsets.top
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        applyTheme(ThemeManager.shared.currentTheme)
        collectionView.register(PhotosViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(loadPhotosData), for: .valueChanged)
        loadPhotosData()
    }
    
    // Загрузка данных
    @objc private func loadPhotosData() {
        APIManager.shared.getData(for: .photos) { [weak self] (result: Result<[PhotosModel.Response.Photo], Error>) in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing()
                switch result {
                case .success(let photos):
                    self?.data = photos
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showErrorAlert(error)
                }
            }
        }
    }

    private func showErrorAlert(_ error: Error) {
        let message = "Не удалось обновить данные. Ошибка: \(error.localizedDescription)"
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("photos data count "+data.count.description)
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotosViewCell else {
            fatalError("Unable to dequeue PhotosViewCell")
        }
        
        let photo = data[indexPath.item]
        // Настройка ячейки с использованием данных модели
        cell.configureWithPhoto(with: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
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
        collectionView.backgroundColor = theme.backgroundColor
        refresh.tintColor = theme.labelTextColor

    }
}
