//
//  SettingsVC.swift
//  CmrUI
//

import UIKit

private struct Constants {
    let darkGradientColor = UIColor(red: 165.0/255.0, green: 191.0/255.0, blue: 202.0/255.0, alpha: 1.0)
    let lightGradientColor = UIColor(red: 94.0/255.0, green: 123.0/255.0, blue: 157.0/255.0, alpha: 1.0)
    let orangeBorderColor = UIColor(red: 246.0/255.0, green: 218.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    let redStorageButtonColor = UIColor(red: 204.0/255.0, green: 92.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    let greenStorageButtonColor = UIColor(red: 183.0/255.0, green: 210.0/255.0, blue: 187.0/255.0, alpha: 1.0)
}

class SettingsVC: UIViewController {
    
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var deviceStorageView: SettingsPropertyView!
    @IBOutlet weak var cloudStorageView: SettingsPropertyView!
    @IBOutlet weak var moreStorageButton: UIButton!
    @IBOutlet weak var deleteAppSwitchView: SwitchView!
    @IBOutlet weak var narrationModeSwitchView: SwitchView!
    @IBOutlet weak var resolutionSegmentedView: SegmentedView!
    @IBOutlet weak var videoLengthSegmentedView: SegmentedView!
    @IBOutlet weak var autoSleepSegmentedView: SegmentedView!
    @IBOutlet weak var devicePropertiesView: DevicePropertiesView!
    
    @IBOutlet weak var bottomOffset: NSLayoutConstraint!
    @IBOutlet weak var topOffset: NSLayoutConstraint!
    
    fileprivate let constants: Constants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gradientView.addGradient(colors: [constants.darkGradientColor,
                                            constants.lightGradientColor],
                                   start: CGPoint(x:0.5, y:0),
                                   end: CGPoint(x:0.5, y:1))
    }
    
    func setupAppearance() {
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        deviceStorageView.setBordColor(color: constants.orangeBorderColor)
        cloudStorageView.setBordColor(color: constants.greenStorageButtonColor)
        
        let attributes = [NSAttributedStringKey.foregroundColor: constants.redStorageButtonColor,
                          NSAttributedStringKey.font:  UIFont(name: "HelveticaNeue-Medium", size: 12.0) ?? 15,
                          NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        moreStorageButton?.setAttributedTitle(NSAttributedString(string: "PURCHASE MORE STORAGE", attributes: attributes), for: .normal)
        
        deleteAppSwitchView.swichValueCallback = { [weak self] newValue in
            self?.showAlert(value: newValue)
            //Processing such events
        }
        narrationModeSwitchView.swichValueCallback = { [weak self] newValue in
            self?.showAlert(value: newValue)
            //Processing such events
        }
        
        resolutionSegmentedView.segments = ["1080p", "720p"]
        resolutionSegmentedView.selectIndex(index: 0)
        resolutionSegmentedView.segmentedValueCallback = { [weak self] newValue in
            self?.showAlert(value: newValue)
        }
        videoLengthSegmentedView.segments = ["15 secs", "30 secs", "45 secs"]
        videoLengthSegmentedView.selectIndex(index: 1)
        videoLengthSegmentedView.segmentedValueCallback = { [weak self] newValue in
            self?.showAlert(value: newValue)
        }
        autoSleepSegmentedView.segments = ["30 Secs", "2 Mins", "5 Minth", "Never"]
        autoSleepSegmentedView.selectIndex(index: 0)
        autoSleepSegmentedView.segmentedValueCallback = { [weak self] newValue in
            self?.showAlert(value: newValue)
        }
        
        if Device.IS_4_INCHES_OR_SMALLER() {
            bottomOffset.constant = view.frame.size.height * 0.14
            topOffset.constant = view.frame.size.height * 0.005
        }
        
        devicePropertiesView.checkForUpgradecallback = { [weak self] in
            self?.showAlert(value: 0)
        }
    }
    
    func showAlert(value: Int) {
        let alert = UIAlertController(title: "Swich changed", message: "\(value)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.removeFromParentViewController()
        })
        self.present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        gradientView.updateGradientLayerFrame()
    }
    
    // MARK: Actions
    
    @IBAction func purchaseStoragePressed() {
    }
    
    @IBAction func shareToFacebookPressed() {
        self.showShareDialog(network: "Facebook")
    }
    
    @IBAction func shareToTwitterPressed() {
        self.showShareDialog(network: "Twitter")
    }
    
    @IBAction func shareToInstagramPressed() {
        self.showShareDialog(network: "Instagram")
    }
    
    func showShareDialog(network: String) {
        let alert = UIAlertController(title: "Would you like to share to", message: network, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            self.shareImage()
            self.removeFromParentViewController()
        })
        alert.addAction(UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
            self.removeFromParentViewController()
        })
        self.present(alert, animated: true)
    }
    
    func shareImage() {
        let image = UIImage(named: "pict_1")
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
