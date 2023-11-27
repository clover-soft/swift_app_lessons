//
//  FriendsViewCell.swift
//  lesson02Hw01
//
//  Created by yakov on 27.11.2023.
//

import UIKit

final class FriendsViewCell: UITableViewCell {

    private var circle: UIView = {
        let circle = UIView()
        circle.backgroundColor = .darkGray
        circle.layer.cornerRadius = 30
        circle.clipsToBounds = true
        
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        circle.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
//            imageView.widthAnchor.constraint(equalTo: circle.widthAnchor),
//            imageView.heightAnchor.constraint(equalTo: circle.heightAnchor)
            imageView.widthAnchor.constraint(equalToConstant: 40), // Increase the width
            imageView.heightAnchor.constraint(equalToConstant: 40) // Increase the height
     
        ])
        
        return circle
    }()

    private var text1: UILabel = {
        let label = UILabel()
        label.text = "Friend"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(circle)
        contentView.addSubview(text1)
        setupConstraints()
    }
    
    private func setupConstraints() {
        circle.translatesAutoresizingMaskIntoConstraints = false
        text1.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            circle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            circle.heightAnchor.constraint(equalToConstant: 60),
            circle.widthAnchor.constraint(equalTo: circle.heightAnchor),
            circle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            text1.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            text1.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 10),
            text1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])
    }
}
