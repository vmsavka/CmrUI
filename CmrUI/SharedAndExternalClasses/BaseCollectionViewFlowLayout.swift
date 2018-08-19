//
//  BaseCollectionViewFlowLayout.swift
//  CmrUI
//
// Based on OCTBaseCollectionViewLayout
//

import UIKit

public protocol CollectionViewFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class BaseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private var _layoutMap = [IndexPath : UICollectionViewLayoutAttributes]()
    private var _columnsYoffset: [CGFloat]!
    private var _contentSize: CGSize!
    
    private(set) var totalItemsInSection = 0
    
    var totalColumns = 1
    var interItemsSpacing: CGFloat = 14
    
    //MARK: getters
    var contentInsets: UIEdgeInsets {
        return collectionView!.contentInset
    }
    
    override var collectionViewContentSize: CGSize {
        return _contentSize
    }
    
    func getLayoutMap() -> [IndexPath : UICollectionViewLayoutAttributes] {
        return _layoutMap
    }
    
    //MARK: Override methods
    override func prepare() {
        _layoutMap.removeAll()
        _columnsYoffset = Array(repeating: 0, count: totalColumns)
        var totalHeight: CGFloat = 0.0
        
        totalItemsInSection = collectionView!.numberOfItems(inSection: 0)
        
        if totalItemsInSection > 0 && totalColumns > 0 {
            self.calculateItemsSize()
            
            var itemIndex = 0
            var contentSizeHeight: CGFloat = 0
            
            while itemIndex < totalItemsInSection {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let columnIndex = self.columnIndexForItemAt(indexPath: indexPath)
                
                let attributeRect = calculateItemFrame(indexPath: indexPath, columnIndex: columnIndex, columnYoffset: _columnsYoffset[columnIndex])
                let targetLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                targetLayoutAttributes.frame = attributeRect
                
                contentSizeHeight = max(attributeRect.maxY, contentSizeHeight)
                _columnsYoffset[columnIndex] = attributeRect.maxY + interItemsSpacing
                _layoutMap[indexPath] = targetLayoutAttributes
                
                itemIndex += 1
            }
            
            totalHeight += contentSizeHeight
        }
//}
            
        _contentSize = CGSize(width: collectionView!.bounds.width - contentInsets.left - contentInsets.right,
                                  height: totalHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()

        for (_, layoutAttributes) in _layoutMap {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }

        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return _layoutMap[indexPath]
    }
    
    //MARK: Abstract methods
    func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        return indexPath.item % totalColumns
    }
    func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        return CGRect.zero
    }
    
    func calculateItemsSize() {}
}
