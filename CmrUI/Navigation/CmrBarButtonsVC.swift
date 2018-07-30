//
//  CmrBarButtonsVC.swift
//  CmrUI
//

import UIKit

struct CmrTabBarColours {
    static let tabBarBackgroundColor = UIColor(red: 151.0/255.0, green: 194.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    static let tabBarSelectedItemColor = UIColor(red: 38.0/255.0, green: 42.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    static let notificationColor = UIColor(red: 253.0/255.0, green: 291.0/255.0, blue: 0.0/255.0, alpha: 1.0)
}

fileprivate struct CmrTabBarSizes {
    static let kRadiusBarItem: CGFloat = 0.088
}

protocol CmrBarButtonsProtocol {
    func selectTab(tab: ContainerTab)
}

private let reuseIdentifier = "CmrBarButtonCell"

class CmrBarButtonsVC: UICollectionViewController, CmrBarButtonsLayoutDelegate {
    
    fileprivate var dataSource = [ContainerTab]()
    var delegateContainer: CmrBarButtonsProtocol?
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [.feedItem, .profileItem, .galleryItem, .settingsItem, .shoppingItem]
        
        // Register cell classes
        self.collectionView?.register(UINib(nibName: "CmrBarButtonCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        
        selectedIndex = IndexPath(row: 0, section: 0)
        let cell = collectionView?.cellForItem(at: selectedIndex!) as! CmrBarButtonCell
        cell.updateSelection(isSelected: true)
        updateShadowForCell(isShown: true, indexPath: selectedIndex!)
        collectionView?.bringSubview(toFront: cell)
    }
    
    func setupAppearance() {
        view.layer.cornerRadius = (delegateContainer as! UIViewController).view.frame.size.width * CmrTabBarSizes.kRadiusBarItem
        view.backgroundColor = CmrTabBarColours.tabBarBackgroundColor
        view.layer.masksToBounds = true
        
        self.customCollectionViewLayout?.delegate = self
        self.customCollectionViewLayout?.numberOfColumns = dataSource.count
    }
    
    public var customCollectionViewLayout: CmrBarButtonsViewLayout? {
        get {
            return collectionViewLayout as? CmrBarButtonsViewLayout
        }
        set {
            if newValue != nil {
                self.collectionView?.collectionViewLayout = newValue!
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CmrBarButtonCell
        cell.backgroundColor = CmrTabBarColours.tabBarBackgroundColor
        cell.setImage(image: dataSource[indexPath.row].image() ?? UIImage())
        cell.layer.shadowColor = UIColor.black.cgColor
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension CmrBarButtonsVC {
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        self.delegateContainer?.selectTab(tab: dataSource[indexPath.row])
        let cell = collectionView.cellForItem(at: indexPath) as! CmrBarButtonCell
        
        cell.updateSelection(isSelected: true)
        updateShadowForCell(isShown: true, indexPath: indexPath)
        //collectionView.cellForItem(at: indexPath)?.backgroundColor = CmrTabBarColours.tabBarSelectedItemColor
        
        if let index = selectedIndex, index.row != indexPath.row  {
            //cell.updateSelection(isSelected: false)
            updateShadowForCell(isShown: false, indexPath: index)
            collectionView.cellForItem(at: index)?.backgroundColor = CmrTabBarColours.tabBarBackgroundColor
        }
        selectedIndex = indexPath
        
        collectionView.bringSubview(toFront: cell)
        
        return true
    }
    
    func updateShadowForCell(isShown: Bool, indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath) as! CmrBarButtonCell
        if (isShown) {
            cell.clipsToBounds = false
            cell.layer.masksToBounds = false
            cell.layer.shadowRadius = 15
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        } else {
            cell.clipsToBounds = true
            cell.layer.masksToBounds = true
            cell.layer.shadowOpacity = 0.8
        }
    }
}

// MARK: CmrBarButtonsLayoutDelegate

extension CmrBarButtonsVC {
    
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat {
        let totalWidth = self.view.frame.size.width
        let offsetCellConst = 0.26
        let midWidth = Double(totalWidth) / (2 * offsetCellConst + Double(dataSource.count))
        let sideWidth = midWidth * offsetCellConst + midWidth
        
        return indexPath.row == 0 || indexPath.row == dataSource.count - 1 ? CGFloat(sideWidth) : CGFloat(midWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height
    }
}
