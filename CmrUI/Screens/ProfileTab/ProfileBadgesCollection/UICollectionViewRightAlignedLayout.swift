//
//  UICollectionViewRightAlignedLayout.swift
//  CmrUI
//

import UIKit

extension UICollectionViewLayoutAttributes {
    func rightAlignFrame(onWidth width: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.x = width - frame.size.width
        self.frame = frame
    }
}

protocol UICollectionViewDelegateRightAlignedLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
}

class UICollectionViewRightAlignedLayout: UICollectionViewFlowLayout {
    
    public var delegate: UICollectionViewDelegateRightAlignedLayout!
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributes = super.layoutAttributesForElements(in: rect)
        var updatedAttributes: [AnyHashable]? = nil
        if let anAttributes = originalAttributes {
            updatedAttributes = anAttributes
        }
        for attributes: UICollectionViewLayoutAttributes? in originalAttributes ?? [UICollectionViewLayoutAttributes?]() {
            if attributes?.representedElementKind == nil {
                var index: Int? = nil
                if let anAttributes = attributes {
                    index = (updatedAttributes as NSArray?)?.index(of: anAttributes)
                }
                if let aPath = attributes?.indexPath, let aPath1 = layoutAttributesForItem(at: aPath) {
                    updatedAttributes?[index ?? 0] = aPath1
                }
            }
        }
        return updatedAttributes as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let currentItemAttributes: UICollectionViewLayoutAttributes? = super.layoutAttributesForItem(at: indexPath)
        let isFirstItemInSection: Bool = indexPath.item == 0
        if isFirstItemInSection {
            currentItemAttributes?.rightAlignFrame(onWidth: (collectionView?.frame.size.width)!)
            return currentItemAttributes
        }
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousFrame: CGRect? = layoutAttributesForItem(at: previousIndexPath)?.frame
        let currentFrame: CGRect? = currentItemAttributes?.frame
        let strecthedCurrentFrame = CGRect(x: 0, y: currentFrame?.origin.y ?? 0.0, width: (collectionView?.frame.size.width)!, height: currentFrame?.size.height ?? 0.0)
        
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // widht intersects the previous frame then they are on the same line
        let isFirstItemInRow = !(previousFrame?.intersects(strecthedCurrentFrame))!
        if isFirstItemInRow {
            currentItemAttributes?.rightAlignFrame(onWidth: (collectionView?.frame.size.width)!)
            return currentItemAttributes
        }
        let previousFrameLeftPoint = previousFrame?.origin.x
        let frame: CGRect? = currentItemAttributes?.frame
        let minimumInteritemSpacing = evaluatedMinimumInteritemSpacingForItem(at: indexPath.row)
        var newFrame = frame
        newFrame?.origin.x = previousFrameLeftPoint! - minimumInteritemSpacing - (frame?.size.width ?? 0.0)
        currentItemAttributes?.frame = newFrame ?? CGRect.zero
        return currentItemAttributes
        
    }
}

extension UICollectionViewRightAlignedLayout: UICollectionViewDelegateFlowLayout {
    
    func evaluatedMinimumInteritemSpacingForItem(at index: Int) -> CGFloat {
        if (collectionView?.delegate?.responds(to: #selector(self.delegate.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))))! {
            guard let delegate = collectionView?.delegate as? UICollectionViewDelegateRightAlignedLayout? else { return minimumInteritemSpacing }
            return delegate?.collectionView!(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: index) ?? minimumInteritemSpacing
        } else {
            return minimumInteritemSpacing
        }
    }
}
