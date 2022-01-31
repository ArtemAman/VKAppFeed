//
//  NewsFeedCellLayoutCalculator.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 31.01.2022.
//

import UIKit

protocol FeedCellLayoutCalculateProtocol {
    
    func sizes(postText: String?, photoAttachment: PhotoAttachmentVeiwPhoto?) -> CellFeedSizes
    
}

struct Sizes: CellFeedSizes {
    
    var postLabelFrame: CGRect
    var postImageFrame: CGRect
    var totalHeight: CGFloat
    
}

final class FeedCellLayoutCalculator:FeedCellLayoutCalculateProtocol  {
    
    private let screenWidth:CGFloat
     
    init(screenWidth:CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachment: PhotoAttachmentVeiwPhoto?) -> CellFeedSizes {
        
        
        let cardWidth = screenWidth - CellConstants.cardViewInsets.left - CellConstants.cardViewInsets.right
        
        
        // postLableFrame calc
        var postLableFrame = CGRect(origin: CGPoint(x: CellConstants.postLabelInsets.left, y: CellConstants.postLabelInsets.top ), size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = cardWidth - CellConstants.postLabelInsets.left - CellConstants.postLabelInsets.right
            let height = text.height(width: width, font: CellConstants.postFont)
            
            postLableFrame.size = CGSize(width: width, height: height)
            
        }
        
        
        // postImageFrame calc
        
        let attachmentTop = postLableFrame.size == CGSize.zero ? CellConstants.postLabelInsets.top : postLableFrame.maxY + CellConstants.postLabelInsets.bottom
        var postImageFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
        if let attachment = photoAttachment {
            
            let attheight: Float = Float(attachment.height)
            let attwidth: Float = Float(attachment.width)
            let ratio:CGFloat = CGFloat(attheight / attwidth)
            postImageFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize(width: cardWidth, height: cardWidth * ratio))

        }
        
        let total = max(postImageFrame.maxY, postLableFrame.maxY) + CellConstants.bottomViewHeight + 5
         
        return Sizes(postLabelFrame: postLableFrame,
                     postImageFrame: postImageFrame,
                     totalHeight: total)
    
    }
}
