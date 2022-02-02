//
//  GalleryCollectionView.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 01.02.2022.
//

import UIKit

class GalleryCollectionView: UICollectionView {
    
    var photos = [PhotoAttachmentVeiwPhoto]()
    
    init() {
        let layout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        layout.delegate = self
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
    }
    
    func set(photos:[PhotoAttachmentVeiwPhoto]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        self.reloadData()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, RowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageUrl: photos[indexPath.row].photoUrl)
        return cell
    }
    

    func collectionView(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
    
    
}
