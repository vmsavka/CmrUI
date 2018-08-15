//
//  CmrContainerVC.swift
//  CmrUI
//

import UIKit

fileprivate struct CmrBarButtonsSizes {
    static let kSideOffset: CGFloat = 0.064
    static let kBottomOffset: CGFloat = 0.055
    static let kHeightBar: CGFloat = 0.176
}

class CmrContainerVC: UIViewController {
    
    private var tab: ContainerTab?
    private var currentVC: UIViewController?
    @IBOutlet weak var containerBarButtonsView: UIView!
    @IBOutlet weak var barButtonsView: UIView!
    private var barButtonsVC: CmrBarButtonsVC?
    
    var alert: UIAlertController? // Will implement it later, maybe it will replaced by PXAlertView
    private lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray) // Will move it to separate class later
    
    //Constraints for sizes and insects of bar buttons view
    @IBOutlet weak var leadingBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightBarConstraint: NSLayoutConstraint!
    
    static let sharedInstance = CmrContainerVC()
    
    fileprivate var dataSource = [ContainerTab]()
    
    var stackViews: [UIView]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = [.feedItem, .dashboardItem, .galleryItem, .settingsItem, .shoppingItem]
        setupAppearance()
    }
    
    //MARK: - Helpers
    
    func setupAppearance(){
        //Will implement NavigationRouter later and remove follow code
        //Also custom NavigationBar or shared helper will be useful
        //Make navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.setNavigationBarHidden(true, animated: true)

        NavigationRouter.shared.navigationContiner = self
        
        if tab == nil {
            transition(to: .feedItem)
        }
        
        barButtonsView.clipsToBounds = true
        barButtonsView.layer.masksToBounds = true
        
        //Adjust size of bar buttons
        let width = view.frame.size.width
        leadingBarConstraint.constant = width * CmrBarButtonsSizes.kSideOffset
        trailingBarConstraint.constant = width * CmrBarButtonsSizes.kSideOffset
        bottomBarConstraint.constant = width * CmrBarButtonsSizes.kBottomOffset
        heightBarConstraint.constant = width * CmrBarButtonsSizes.kHeightBar
    }
    
    func updateBarButtons(fromView someView: UIView) {
        someView.bringSubview(toFront: barButtonsView)
    }
    
    func loadInitialView() {
        showActivityIndicator()
    }
    
    func clearStackSubviews() {
        for view in stackViews! {
            view.removeFromSuperview()
        }
        stackViews = []
    }

    private func showActivityIndicator() {
        // Activity indicator setup and rendering
    }
    
    private func render(viewController: UIViewController, transitionType: CATransition) {
        // Shows arbitrary viewController from current
    }
    
    private func displayError(error: Error) {
        // Provides interface for error handling
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of: segue.destination) == CmrBarButtonsVC.self {
            barButtonsVC = (segue.destination as! CmrBarButtonsVC)
            barButtonsVC?.delegateContainer = self
        }
    }
}

// MARK: - Tranasitions

extension CmrContainerVC {
    func transition(to newTab: ContainerTab) {
        currentVC?.removeFromParentViewController()
        clearStackSubviews()
        let vc = viewController(for: newTab)
        if (newTab != .feedItem) {
            vc.view.backgroundColor = UIColor.random()
        }
        add(vc)
        currentVC = vc
        tab = newTab
        updateBarButtons(fromView: view)
        navigationItem.title = NSLocalizedString((newTab.tabTitle()), comment: "")
    }
    
    func add(_ child: UIViewController) {
            addChildViewController(child)
            view.addSubview(child.view)
            child.didMove(toParentViewController: self)
            stackViews?.append(child.view)
        }
        
    func remove() {
            guard parent != nil else {
                return
            }
            
            willMove(toParentViewController: nil)
            removeFromParentViewController()
            view.removeFromSuperview()
    }
}

extension CmrContainerVC: CmrBarButtonsProtocol {
    func selectTab(tab: ContainerTab) {
        self.transition(to: tab)
    }
}

private extension CmrContainerVC {
    func viewController(for tab: ContainerTab) -> UIViewController {
        switch tab {
        case .feedItem:
            let board = UIStoryboard.storyboardWith(name: .newsFeed)
            let controller = board.instantiateInitialViewController()
            return controller!
        case .dashboardItem:
            let board = UIStoryboard.storyboardWith(name: .dashboard)
            let controller = board.instantiateInitialViewController()
            return controller!
        case .galleryItem:
            return UIViewController()
        case .settingsItem:
            let board = UIStoryboard.storyboardWith(name: .settings)
            let controller = board.instantiateInitialViewController()
            return controller!
        case .shoppingItem:
            return UIViewController()
        case .count:
            return UIViewController()
        }
    }
}

enum ContainerTab: Int {
        typealias RawValue = Int
        
        case feedItem = 0
        case dashboardItem = 1
        case galleryItem = 2
        case settingsItem = 3
        case shoppingItem = 4
        case count = 5
        
        func tabTitle() -> String {
            switch self {
            case .feedItem: return "Newsfeed"
            case .dashboardItem: return "Dashboard"
            case .galleryItem: return "Gallery"
            case .settingsItem: return "Settings"
            case .shoppingItem: return "Shopping"
            case .count: return ""
            }
        }
        
        func image() -> UIImage? {
            switch self {
            case .feedItem:
                return UIImage(named:"FeedTabBarIco")
            case .dashboardItem:
                return UIImage(named:"DashboardTabBarIco")
            case .galleryItem:
                return UIImage(named:"GalleryTabBarIco")
            case .settingsItem:
                return UIImage(named:"SettingsTabBarIco")
            case .shoppingItem:
                return UIImage(named:"ShoppingTabBarIco")
            case .count:
                return nil
            }
        }
        
        static func countOfTabs() -> Int {
            return ContainerTab.count.rawValue
        }
}

//Will move it later
/*
class ErrorViewController: UIViewController {
    var reloadHandler: () -> Void = {}
    
    func handle(_ error: Error) {
        let errorViewController = ErrorViewController()
        errorViewController.reloadHandler = { [weak self] in
            self?.doSomething()
        }
        add(errorViewController)
    }
}
 */
