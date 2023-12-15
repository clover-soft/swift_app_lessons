//
//  File.swift
//  lesson02Hw01
//
//  Created by yakov on 27.11.2023.
//


import UIKit

class PhotosController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var data = [PhotosModel.Response.Photo]()
    private let reuseIdentifier = "PhotoCell"
    private let photos: [UIImage?] = [
        UIImage(named: "vk_logo"),nil,nil,nil,nil,nil
    ]
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let itemsPerRow: CGFloat = 2
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = sectionInsets.left
        layout.minimumLineSpacing = sectionInsets.top
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotosViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotosViewCell else {
            fatalError("Unable to dequeue PhotosViewCell")
        }
        
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        APIManager.shared.getData(for: .photos) { [weak self] photos in
            guard let photos = photos as? [PhotosModel.Response.Photo] else {
                return
            }
            self?.data = photos
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
