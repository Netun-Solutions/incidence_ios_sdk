//
//  IABaseViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

public class IABaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public var baseViewModel: IABaseViewModel!
    
    var forceShowBackButton = false
    var navigationColor: UIColor {
        get {
            //return UIColor.app(.black600) ?? .black
            let color : UIColor? = IncidenceLibraryManager.shared.getTextColor();
            return color ?? UIColor.app(.black600) ?? .black
            
        }
    }
    
    lazy var loadingContainerView: UIView = {
        return UIView()
    }()
    lazy var loadingContainerView2: UIView = {
        return UIView()
    }()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLeftAlignedNavigationItemTitle()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        if (loadDataDelay()) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                 self.loadData()
            }
        }
        else {
            self.loadData()
        }
    }
    
    func setUpUI() {
    }
    
    func loadDataDelay() -> Bool {
        return false
    }
    func loadData() {
    }
    func reloadData() {
    }
    
    private func setLeftAlignedNavigationItemTitle() {
        
        guard let title = baseViewModel.navigationTitle else { return }
        self.navigationItem.leftItemsSupplementBackButton = false

        var leftNavigationButtons: [UIBarButtonItem] = []

        //if forceShowBackButton || (navigationController?.viewControllers.count ?? 0) > 1 {
        if forceShowBackButton || (navigationController?.viewControllers.count ?? 0) > 1 || true {
            let image = UIImage.app( "Direction=Left")?.withRenderingMode(.alwaysTemplate)
            let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backPressed))
            backButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -6)
            leftNavigationButtons.append(backButton)
            navigationItem.hidesBackButton = true
        
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        if (self.navigationItem.titleView == nil) {

            let item = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
            item.isEnabled = false
            
            if leftNavigationButtons.isEmpty {
                let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                space.width = 15
                leftNavigationButtons.append(space)
            }
            
            leftNavigationButtons.append(item)
            navigationItem.leftBarButtonItems = leftNavigationButtons
        }
        
        navigationController?.navigationBar.tintColor = navigationColor
        if let font = UIFont.app(.primarySemiBold, size: 16)  {
            let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: navigationColor]
            navigationController?.navigationBar.titleTextAttributes = attributes
            navigationItem.leftBarButtonItems?.forEach({
                $0.setTitleTextAttributes(attributes, for: .normal)
                $0.setTitleTextAttributes(attributes, for: .disabled)
            })
        }
    }
    
    @objc func backPressed(){
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func backInfoPressed(){
        navigationController?.popViewController(animated: true)
    }

    func showHUD() {
        guard let targetView = self.view else { return }
        
        targetView.addSubview(loadingContainerView)
        loadingContainerView.anchor(top: targetView.topAnchor, left: targetView.leftAnchor, bottom: targetView.bottomAnchor, right: targetView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        if loadingContainerView.subviews.count == 0 {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.color = UIColor.app(.incidencePrimary)
            loadingContainerView.addSubview(activityIndicator)
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            loadingContainerView.addSubview(blurEffectView)
            blurEffectView.anchor(top: loadingContainerView.topAnchor, left: loadingContainerView.leftAnchor, bottom: loadingContainerView.bottomAnchor, right: loadingContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
            blurEffectView.alpha = 0.3
            
            loadingContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)

            loadingContainerView.addSubview(activityIndicator)
            activityIndicator.anchor(widthConstant: 80, heightConstant: 80)
            activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            activityIndicator.anchorCenterXToSuperview()
            activityIndicator.anchorCenterYToSuperview()
        }
        
        if let activityIndicator = loadingContainerView.subviews.last as? UIActivityIndicatorView {
            activityIndicator.startAnimating()
        }
    }
    
    func showHUD2() {
        guard let targetView = self.view else { return }
        
        targetView.addSubview(loadingContainerView2)
        loadingContainerView2.anchor(top: targetView.topAnchor, left: targetView.leftAnchor, bottom: targetView.bottomAnchor, right: targetView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        loadingContainerView2.isUserInteractionEnabled = false
        
        if loadingContainerView2.subviews.count == 0 {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.color = UIColor.app(.incidencePrimary)
            loadingContainerView2.addSubview(activityIndicator)
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            loadingContainerView2.addSubview(blurEffectView)
            blurEffectView.anchor(top: loadingContainerView2.topAnchor, left: loadingContainerView2.leftAnchor, bottom: loadingContainerView2.bottomAnchor, right: loadingContainerView2.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
            blurEffectView.alpha = 0.3
            blurEffectView.isUserInteractionEnabled = false
            
            loadingContainerView2.backgroundColor = UIColor.white.withAlphaComponent(0.1)

            loadingContainerView2.addSubview(activityIndicator)
            activityIndicator.anchor(widthConstant: 80, heightConstant: 80)
            activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            activityIndicator.anchorCenterXToSuperview()
            activityIndicator.anchorCenterYToSuperview()
        }
        
        if let activityIndicator = loadingContainerView2.subviews.last as? UIActivityIndicatorView {
            activityIndicator.startAnimating()
        }
    }
    
    func hideHUD() {
        if let activityIndicator = loadingContainerView.subviews.last as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
        }
        loadingContainerView.removeFromSuperview()
    }
    
    func hideHUD2() {
        if let activityIndicator = loadingContainerView2.subviews.last as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
        }
        loadingContainerView2.removeFromSuperview()
    }
    
    func onBadResponse(result:IResponse)
    {
        onBadResponse(result: result, handler: nil);
    }
    func onBadResponse(result:IResponse, handler: ((UIAlertAction) -> Void)? = nil)
    {
        if (result != nil && result.message != nil)
        {
            if let action = result.action, action == Constants.WS_RESPONSE_ACTION_INVALID_SESSION {
                
                showAlert(message: result.message!, completion: {
                    Core.shared.signOut()
                })
            }
            else
            {
                showAlert(message: result.message!, completion: nil, handler: handler)
            }
        }
    }
    
    func showAlert(message:String)
    {
        let title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        showAlert(title: title, message: message, completion: nil)
    }
    func showAlert(message:String, completion: (() -> Void)? = nil, handler: ((UIAlertAction) -> Void)? = nil)
    {
        let title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        showAlert(title: title, message: message, completion: completion, handler: handler)
    }
    
    func showAlert(title:String, message:String)
    {
        showAlert(title: title, message: message, completion: nil)
    }
    func showAlert(title:String, message:String, completion: (() -> Void)? = nil, handler: ((UIAlertAction) -> Void)? = nil)
    {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "accept".localized(), style: UIAlertAction.Style.default, handler: handler))

        // show the alert
        self.present(alert, animated: true, completion: completion)
    }
}
