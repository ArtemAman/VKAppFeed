//
//  NewsFeedCellLayoutCalculator.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 31.01.2022.
//

import UIKit

protocol FeedCellLayoutCalculateProtocol {
    
    func sizes(postText: String?, photoAttachments: [PhotoAttachmentVeiwPhoto], isFullSized: Bool) -> CellFeedSizes
    
}

struct Sizes: CellFeedSizes {
    
    var postLabelFrame: CGRect
    var postImageFrame: CGRect
    var totalHeight: CGFloat
    var moreButtonFrame: CGRect
    
}

final class FeedCellLayoutCalculator:FeedCellLayoutCalculateProtocol {
    
    private let screenWidth:CGFloat
     
    init(screenWidth:CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachments: [PhotoAttachmentVeiwPhoto], isFullSized: Bool) -> CellFeedSizes {
        
        var showMoreButton = false
        
        let cardWidth = screenWidth - CellConstants.cardViewInsets.left - CellConstants.cardViewInsets.right
        
        // postLableFrame calc
        var postLableFrame = CGRect(origin: CGPoint(x: CellConstants.postLabelInsets.left, y: CellConstants.postLabelInsets.top ), size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = cardWidth - CellConstants.postLabelInsets.left - CellConstants.postLabelInsets.right
            var height = text.height(width: width, font: CellConstants.postFont)
            
            let limitHeight = CellConstants.postFont.lineHeight * CellConstants.postMinLinesToShowButton
            
            if !isFullSized && height > limitHeight {
                height = CellConstants.postFont.lineHeight * CellConstants.postMinLinesShowedByButton
                showMoreButton = true
            }
            
            postLableFrame.size = CGSize(width: width, height: height)
            
        }
        
        // moreButton
        
        var moreButtonSize = CGSize.zero
        if showMoreButton {
            moreButtonSize = CellConstants.moreTexButtonSize
        }
        
        let moreButtonOrigin = CGPoint(x: 8, y: postLableFrame.maxY)
        let moreButtonFrame = CGRect(origin: moreButtonOrigin, size: moreButtonSize)
        
        
        // postImageFrame calc
        
        let attachmentTop = postLableFrame.size == CGSize.zero ? CellConstants.postLabelInsets.top : moreButtonFrame.maxY + CellConstants.postLabelInsets.bottom
        var postImageFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
        if let attachment = photoAttachments.first {
            
            let attheight: Float = Float(attachment.height)
            let attwidth: Float = Float(attachment.width)
            let ratio:CGFloat = CGFloat(attheight / attwidth)
            if photoAttachments.count == 1 {
                postImageFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize(width: cardWidth, height: cardWidth * ratio))
            } else if photoAttachments.count > 1 {
                var photoSizes = [CGSize]()
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photoSizes.append(photoSize)
                }
                let rowHeight = RowLayout.rowHeightCounter(superViewWidth: cardWidth, photoSizes: photoSizes)
                postImageFrame.size = CGSize(width: cardWidth, height: rowHeight!)
                                        
            }  

        }
        
        // total calc
        
        let total = max(postImageFrame.maxY, postLableFrame.maxY) + CellConstants.bottomViewHeight + 5
         
        return Sizes(postLabelFrame: postLableFrame,
                     postImageFrame: postImageFrame,
                     totalHeight: total,
                     moreButtonFrame: moreButtonFrame)
    
    }
}
