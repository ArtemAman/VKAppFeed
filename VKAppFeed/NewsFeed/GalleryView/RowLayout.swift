//
//  RowLayout.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 01.02.2022.
//

import UIKit

protocol RowLayoutDelegate: class {
    
    func collectionView (collectionView: UICollectionView, indexPath: IndexPath) -> CGSize
}

class RowLayout:UICollectionViewFlowLayout {
    
    weak var delegate: RowLayoutDelegate!
    static var numberOfRows = 1
    fileprivate var cellPadding:CGFloat = 8
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentWidth:CGFloat = 0
    fileprivate var contentHeight:CGFloat {
        
        guard let collectionView = collectionView else { return 0}
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        contentWidth = 0
        cache = []
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        var photoSizes = [CGSize]()
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView: collectionView, indexPath: indexPath)
            photoSizes.append(photoSize)
        }
        
        let superViewWidth  = collectionView.frame.width
        guard var rowHeight = RowLayout.rowHeightCounter(superViewWidth: superViewWidth, photoSizes: photoSizes) else { return }
        
        rowHeight = rowHeight / CGFloat(RowLayout.numberOfRows)
        
        let photosRatios = photoSizes.map { $0.height / $0.width }
        
        var yOffset = [CGFloat]()
        for row in 0 ..< RowLayout.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        var row = 0
        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let ratio = photosRatios[indexPath.row]
            let width = rowHeight / ratio
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribure = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribure.frame = insetFrame
            cache.append(attribure)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
            
        }
        
    }
    
    // READ IT AGAIN!!!!!!!!
    
    
    static func rowHeightCounter (superViewWidth:CGFloat, photoSizes:[CGSize]) -> CGFloat? {
        
        var rowHight:CGFloat
        
        let photoMinRatio = photoSizes.min { first, second in
            (first.height / first.width) < (second.height / second.width)
        }
        
        guard let myPhotoMinRatio = photoMinRatio else { return nil }
        let difference = superViewWidth / myPhotoMinRatio.width
        
        rowHight = myPhotoMinRatio.height * difference
        rowHight = rowHight * CGFloat(RowLayout.numberOfRows)
        return rowHight
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attr in cache {
            if attr.frame.intersects(rect) {
                visibleLayoutAttributes.append(attr)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[indexPath.row]
    }
    
    
}
