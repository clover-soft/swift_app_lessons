import UIKit

class FriendsViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25 // Радиус зависит от размера вашего изображения
        imageView.layer.masksToBounds = true
        imageView.tintColor = .gray // Цвет иконки
        return imageView
    }()

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let statusIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    // Инициализаторы
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(statusIndicatorView)
        
        // Установка Auto Layout
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        // Расстановка констрейнтов
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 5), // Отступ сверху
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -5), // Отступ снизу
            profileImageView.widthAnchor.constraint(equalToConstant: 50), // Размеры фотографии
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
             
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             
            statusIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            statusIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            statusIndicatorView.widthAnchor.constraint(equalToConstant: 10), // Размеры индикатора статуса
            statusIndicatorView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    // Метод для конфигурации ячейки данными
    func configureWithFriend(_ friend: FriendsModel.Response.Friend) {
        nameLabel.text = friend.firstName + " " + friend.lastName

        // Асинхронная загрузка изображения
        if let url = URL(string: friend.photo) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }.resume()
        }
        
        // Установка индикатора статуса
        if friend.online == 1 {
            statusIndicatorView.backgroundColor = .green
        } else {
            statusIndicatorView.backgroundColor = .gray
        }
    }
}
