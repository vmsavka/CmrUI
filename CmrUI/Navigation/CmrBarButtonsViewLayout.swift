//
//  CmrBarButtonsViewLayout.swift
//  CmrUI
//

import UIKit

public protocol CmrBarButtonsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class CmrBarButtonsViewLayout: UICollectionViewLayout {
    public var delegate: CmrBarButtonsLayoutDelegate!
    
    public var numberOfColumns: Int = 0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat {
        return collectionView!.bounds.height
    }
    
    private var contentWidth: CGFloat {
        return collectionView!.bounds.width
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override public func prepare() {
        if cache.isEmpty {
            var xOffset = [CGFloat]()
            var cWidth = [CGFloat]()
            var previousOffset = 0.0
            for column in 0 ..< numberOfColumns {
                let columnWidth = delegate.collectionView(collectionView!, widthForItemAt: IndexPath(item: column, section: 0))
                xOffset.append(CGFloat(previousOffset))
                previousOffset = Double(CGFloat(previousOffset) + columnWidth)
                cWidth.append(columnWidth)
            }
    
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let frame = CGRect(x: xOffset[indexPath.row], y: 0, width: cWidth[indexPath.row], height: contentHeight)
                let insetFrame = frame.insetBy(dx: 0, dy: 0)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
            }
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
