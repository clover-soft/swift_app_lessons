//
//  ViewController.swift
//  example02
//
//  Created by yakov on 24.11.2023.
//

import UIKit

class ViewController: UIViewController {
    

    private var button1: UIButton = {
        let button = UIButton()
        button.setTitle("Пример таблицы со скролом 1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.backgroundColor = .blue
        return button
    }()
    
    private var button2: UIButton = {
        let button = UIButton()
        button.setTitle("Пример таблицы со скролом 2", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.backgroundColor = .blue
        return button
    }()
    private var button3: UIButton = {
        let button = UIButton()
        button.setTitle("Пример коллекции", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.backgroundColor = .blue
        return button
    }()

    private var isTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        button1.addTarget(self, action: #selector(tap1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(tap2), for: .touchUpInside)
        button3.addTarget(self, action: #selector(tap3), for: .touchUpInside)
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        setupConstraints()
    }
    
    private func setupConstraints() {
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button3.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func tap1() {
        navigationController?.pushViewController(TableExample1ViewController(), animated: true)
    }
    
    @objc func tap2() {
        navigationController?.pushViewController(TableExample2ViewController(), animated: true)
    }

    @objc func tap3() {
        let controller = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }

}

