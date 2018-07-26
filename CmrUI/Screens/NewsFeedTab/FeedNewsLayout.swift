//
//  FeedNewsLayout.swift
//  CmrUI
//

import UIKit

private let kReducedHeightColumnIndex = 1
private let kItemHeightAspect: CGFloat  = 1
private let kInterItemsSpacing: CGFloat = 16

class FeedNewsLayout: BaseCollectionViewFlowLayout {
    private var _columnsXoffset: [CGFloat]!
    
    var delegate: CollectionViewFlowLayoutDelegate!
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        totalColumns = 1
    }
    
    //MARK: Override Abstract methods
    override func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        return indexPath.item % totalColumns
    }
    
    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        let itemHeight = self.delegate.collectionView(collectionView!, heightForItemAt: indexPath)
        
        return CGRect(x: _columnsXoffset[columnIndex], y: columnYoffset, width: (collectionView?.frame.size.width)! - 2 * kInterItemsSpacing, height: itemHeight)
    }
    
    override func calculateItemsSize() {
        let contentWidthWithoutIndents = collectionView!.bounds.width - contentInsets.left - contentInsets.right
        let itemWidth = (contentWidthWithoutIndents - (CGFloat(totalColumns) - 1) * interItemsSpacing) / CGFloat(totalColumns)
        let itemHeight = itemWidth * kItemHeightAspect
        
        let _itemSize: CGSize! = CGSize(width: itemWidth, height: itemHeight)
        
        // Calculating offsets by X for each column
        _columnsXoffset = []
        
        for columnIndex in 0...(totalColumns - 1) {
            _columnsXoffset.append(CGFloat(columnIndex) * (_itemSize.width + interItemsSpacing))
        }
    }
}
