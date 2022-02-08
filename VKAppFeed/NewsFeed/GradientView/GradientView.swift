//
//  GradientView.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 07.02.2022.
//

import UIKit

class GradientView:UIView {
    
    
    let startColor: UIColor = UIColor.red
    let endColor: UIColor = UIColor.blue
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .blue
        translatesAutoresizingMaskIntoConstraints = false
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
    }
    
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
