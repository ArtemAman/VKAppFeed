//
//  GalleryCollectionViewCell.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 01.02.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId:String = "CollectionCell"
    
    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        return imageView
    } ()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(myImageView)

        // myImageView constarints
        NSLayoutConstraint.activate([

            myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            myImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
          ])
            
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myImageView.layer.cornerRadius = 10
        myImageView.layer.masksToBounds = true
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
        
        
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    func set(imageUrl:String?) {
        myImageView.set(imageURL: imageUrl)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
