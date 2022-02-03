//
//  TitleView.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 02.02.2022.
//

import UIKit


protocol TitleViewModel {
    
    var imageUrlString:String? { get }
}

class TitleView: UIView {
    
    
    private lazy var textField: InsetableTextField = InsetableTextField()
        
    
    
    private lazy var avatar: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .orange
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    override init (frame: CGRect) {
        super.init(frame:frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        addSubview(avatar)
        makeContrainsts()
    }
    
    func set(userViewModel: TitleViewModel) {
        avatar.set(imageURL: userViewModel.imageUrlString)
    }
    private func makeContrainsts() {
        
        NSLayoutConstraint.activate([
            
            avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            avatar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            avatar.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 1),
            avatar.widthAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 1),
            
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: avatar.leadingAnchor, constant: -12),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
        ])
    }
    
    
    override var intrinsicContentSize: CGSize{
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        avatar.layer.cornerRadius = avatar.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
