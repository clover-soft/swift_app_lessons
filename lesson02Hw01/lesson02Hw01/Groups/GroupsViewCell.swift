//
//  GroupsViewCell.swift
//  lesson02Hw01
//
//  Created by yakov on 27.11.2023.
//

import Foundation
import UIKit

final class GroupsViewCell: UITableViewCell {

    private var circle: UIView = {
        let circle = UIView()
        circle.backgroundColor = .darkGray
        circle.layer.cornerRadius = 30
        circle.clipsToBounds = true
        
        let imageView = UIImageView(image: UIImage(systemName: "person.3"))
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

    private var groupTitle: UILabel = {
        let label = UILabel()
        label.text = "Group name"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var groupDescription: UILabel = {
        let label = UILabel()
        label.text = "group description"
        label.textColor = .lightGray
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
        contentView.addSubview(groupTitle)
        contentView.addSubview(groupDescription)
        setupConstraints()
    }
    
    private func setupConstraints() {
        circle.translatesAutoresizingMaskIntoConstraints = false
        groupTitle.translatesAutoresizingMaskIntoConstraints = false
        groupDescription.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            circle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            circle.heightAnchor.constraint(equalToConstant: 60),
            circle.widthAnchor.constraint(equalTo: circle.heightAnchor),
            circle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            groupTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            groupTitle.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 10),
            groupTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            
            groupDescription.topAnchor.constraint(equalTo: groupTitle.bottomAnchor, constant: 2),
            groupDescription.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 10),
            groupDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])
    }
}
