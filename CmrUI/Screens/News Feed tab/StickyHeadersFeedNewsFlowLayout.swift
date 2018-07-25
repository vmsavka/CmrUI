//
//  StickyHeadersFeedNewsFlowLayout.swift
//  CmrUI
//

import UIKit

private let kReducedHeightColumnIndex = 1
private let kItemHeightAspect: CGFloat  = 1
private let kInterItemsSpacing: CGFloat = 16

class StickyHeadersFeedNewsFlowLayout: BaseCollectionViewFlowLayout {
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
    
    //////////////////////////////////////////
    
    // MARK: - Collection View Flow Layout Methods
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Helpers
        let sectionsToAdd = NSMutableIndexSet()
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                // Add Layout Attributes
                newLayoutAttributes.append(layoutAttributesSet)
                
                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
                
            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
            }
        }
        
        for section in sectionsToAdd {
            let indexPath = IndexPath(item: 0, section: section)
            
            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                newLayoutAttributes.append(sectionAttributes)
            }
        }
        
        for (_, layoutAttributes) in getLayoutMap() {
            if rect.intersects(layoutAttributes.frame) {
                newLayoutAttributes.append(layoutAttributes)
            }
        }
        
        return newLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        guard let boundaries = boundaries(forSection: indexPath.section) else { return layoutAttributes }
        guard let collectionView = collectionView else { return layoutAttributes }
        
        // Helpers
        let contentOffsetY = collectionView.contentOffset.y
        var frameForSupplementaryView = layoutAttributes.frame
        
        let minimum = boundaries.minimum - frameForSupplementaryView.height
        let maximum = boundaries.maximum - frameForSupplementaryView.height
        
        if contentOffsetY < minimum {
            frameForSupplementaryView.origin.y = minimum
        } else if contentOffsetY > maximum {
            frameForSupplementaryView.origin.y = maximum
        } else {
            frameForSupplementaryView.origin.y = contentOffsetY
        }
        
        layoutAttributes.frame = frameForSupplementaryView
        
        return layoutAttributes
    }
    
    // MARK: - Helper Methods
    
    func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
        // Helpers
        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
        
        // Exit Early
        guard let collectionView = collectionView else { return result }
        
        // Fetch Number of Items for Section
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        
        // Exit Early
        guard numberOfItems > 0 else { return result }
        
        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
            let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
            result.minimum = firstItem.frame.minY
            result.maximum = lastItem.frame.maxY
            
            // Take Header Size Into Account
            result.minimum -= headerReferenceSize.height
            result.maximum -= headerReferenceSize.height
            
            // Take Section Inset Into Account
            result.minimum -= sectionInset.top
            result.maximum += (sectionInset.top + sectionInset.bottom)
        }
        
        return result
    }
}
