//
//  CmrBarButtonsVC.swift
//  CmrUI
//

import UIKit

struct CmrTabBarColours {
    static let tabBarBackgroundColor = UIColor(red: 159.0/255.0, green: 193.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    static let tabBarSelectedItemColor = UIColor(red: 39.0/255.0, green: 42.0/255.0, blue: 45.0/255.0, alpha: 1.0)
}

fileprivate struct CmrTabBarSizes {
    static let bottomOffset: CGFloat = 40.0
    static let sideOffset: CGFloat = 24.0
    static let radiusBarItem: CGFloat = 35.0
}

protocol CmrBarButtonsProtocol {
    func selectTab(tab: ContainerTab)
}

private let reuseIdentifier = "CmrBarButtonCell"

class CmrBarButtonsVC: UICollectionViewController, CmrBarButtonsLayoutDelegate {
    
    fileprivate var dataSource = [ContainerTab]()
    var delegateContainer: CmrBarButtonsProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [.feedItem, .galleryItem, .itemsItem, .settingsItem, .cartItem]
        
        // Register cell classes
        self.collectionView?.register(UINib(nibName: "CmrBarButtonCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        //self.collectionView!.register(CmrBarButtonCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        setupAppearance()
    }
    
    func setupAppearance() {
        view.layer.cornerRadius = CmrTabBarSizes.radiusBarItem
        view.backgroundColor = CmrTabBarColours.tabBarBackgroundColor
        
        self.customCollectionViewLayout?.delegate = self
        self.customCollectionViewLayout?.numberOfColumns = dataSource.count
        
        self.view.backgroundColor = UIColor.white
        self.view.layer.cornerRadius = 35.0
        self.view.layer.masksToBounds = true
        
        setupButtons()
    }
    
    func setupButtons() {
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CmrBarButtonCell
        cell.backgroundColor = UIColor.random()
        cell.setImage(image: dataSource[indexPath.row].image() ?? UIImage())
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.delegateContainer?.selectTab(tab: dataSource[indexPath.row])
        return true
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
