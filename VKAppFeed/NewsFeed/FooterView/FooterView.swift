//
//  FooterView.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 07.02.2022.
//

import UIKit

class FooterView: UIView {
    
    private lazy var myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    } ()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.addSubview(myLabel)
        self.addSubview(loader)
        makeContrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func makeContrainsts() {
        
        NSLayoutConstraint.activate([
            
            myLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            myLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            myLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            loader.topAnchor.constraint(equalTo: myLabel.topAnchor, constant: 15),
            loader.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                        
        ])
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func setTitle(title:String?) {
        loader.stopAnimating()
        myLabel.text = title
    }
    
    
}
