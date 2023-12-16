import UIKit

class GroupsViewCell: UITableViewCell {

    private let groupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25 // половина высоты изображения
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(groupImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)

//        NSLayoutConstraint.activate([
//            groupImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            groupImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            groupImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            groupImageView.widthAnchor.constraint(equalToConstant: 50),
//            groupImageView.heightAnchor.constraint(equalToConstant: 50),
//            
//            nameLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 12),
//            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            nameLabel.topAnchor.constraint(equalTo: groupImageView.topAnchor),
//            
//        ])
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            groupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            groupImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Отступ сверху
            groupImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10), // Отступ снизу
            groupImageView.widthAnchor.constraint(equalToConstant: 50), // Размеры фотографии
            groupImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: groupImageView.topAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configureWithGroup(_ group: GroupsModel.Response.Group) {
        nameLabel.text = group.name
        descriptionLabel.text = group.name
        
        // Асинхронная загрузка изображения
        if let url = URL(string: group.photo) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.groupImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Сброс изображения и текста для переиспользуемой ячейки.
        groupImageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
}
