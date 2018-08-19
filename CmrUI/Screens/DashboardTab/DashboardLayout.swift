//
//  DashboardLayout.swift
//  CmrUI
//

import UIKit

private let kSideItemWidthCoef: CGFloat = 0.3
private let kSideItemHeightAspect: CGFloat = 1
private let kNumberOfSideItems = 1

public protocol DashboardLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, frameForItemAt indexPath: IndexPath, columnNumber: Int) -> CGFloat
}

class DashboardLayout: BaseCollectionViewFlowLayout {
    private var _mainItemSize: CGSize!
    private var _sideItemSize: CGSize!
    private var _columnsXoffset: [CGFloat]!
    
    public var itemSizes: [CGSize]!
    public var xOffsets: [CGFloat]!
    public var yOffsets: [CGFloat]!
    
    var delegate: DashboardLayoutDelegate? = nil
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.totalColumns = 2
    }
    
    //MARK: Override Abstract methods
    override func columnIndexForItemAt(indexPath: IndexPath) -> Int {
        let totalItemsInRow = kNumberOfSideItems + 1
        let columnIndex = indexPath.item % totalItemsInRow
        let columnIndexLimit = totalColumns - 1
        
        return columnIndex > columnIndexLimit  ? columnIndexLimit : columnIndex
    }
    
    override func calculateItemFrame(indexPath: IndexPath, columnIndex: Int, columnYoffset: CGFloat) -> CGRect {
        let size = itemSizes[indexPath.row]
        return CGRect(origin: CGPoint(x: xOffsets[indexPath.row], y: yOffsets[indexPath.row]), size: size)
    }
    
    override func calculateItemsSize() {
        let floatNumberOfSideItems = CGFloat(kNumberOfSideItems)
        let contentWidthWithoutIndents = collectionView!.bounds.width - contentInsets.left - contentInsets.right
        let resolvedContentWidth = contentWidthWithoutIndents - interItemsSpacing
        
        // We need to calculate side item size first, in order to calculate main item height
        let sideItemWidth = resolvedContentWidth * kSideItemWidthCoef
        let sideItemHeight = sideItemWidth * kSideItemHeightAspect
        
        _sideItemSize = CGSize(width: sideItemWidth, height: sideItemHeight)
        
        // Now we can calculate main item height
        let mainItemWidth = resolvedContentWidth - sideItemWidth
        let mainItemHeight = sideItemHeight * floatNumberOfSideItems + ((floatNumberOfSideItems - 1) * interItemsSpacing)
        
        _mainItemSize = CGSize(width: mainItemWidth, height: mainItemHeight)
        
        // Calculating offsets by X for each column
        _columnsXoffset = [0, _mainItemSize.width + interItemsSpacing]
    }
}
