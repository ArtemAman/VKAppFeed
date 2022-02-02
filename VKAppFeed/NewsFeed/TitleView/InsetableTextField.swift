//
//  InsetableTextField.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 02.02.2022.
//

import UIKit

class InsetableTextField:UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        placeholder = "Search"
        font = UIFont.systemFont(ofSize: 14)
        clearButtonMode = .whileEditing
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let image = UIImage(named:"search") 
        leftView = UIImageView(image: image)
        leftView?.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        leftViewMode = .always
        
        
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 0))

    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
