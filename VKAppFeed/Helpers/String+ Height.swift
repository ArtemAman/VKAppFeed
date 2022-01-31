//
//  String+ Height.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 31.01.2022.
//

import Foundation
import UIKit

extension String {
    
    func height(width:CGFloat, font:UIFont) -> CGFloat {
        
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        
        return ceil(size.height)
    }
}
