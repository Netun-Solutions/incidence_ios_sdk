//
//  OnboardingRootViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 27/4/21.
//

import UIKit
import AVFoundation

protocol OnboardingChildDelegate: AnyObject {
    func nextButtonPressed()
}

class OnboardingRootViewController: UIPageViewController, CALayerDelegate {
    
    enum OnboardingPageList: CaseIterable {
        case createAccount
        case sync
        case report
    }
    
    private var viewControllersList: [UIViewController] = []
    var currentIndex: Int {
        get {
            return viewControllersList.firstIndex(of: self.viewControllers!.first!)!
        }
    }
    
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    
    lazy var loadingContainerView: UIView = {
        return UIView()
    }()
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
    
    func hideHUD() {
        if let activityIndicator = loadingContainerView.subviews.last as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
        }
        loadingContainerView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = UIColor.app(.incidencePrimary)
        
        loadData()
    }
    
    
    func loadData()
    {
        self.showHUD()
        self.setUpLogo()
        
        Api.shared.getHomeVideo(completion: { result in
            
            var urlVideo:String? = nil
            self.hideHUD()
            
            if (result.isSuccess())
            {
                if let vid = result.getString(key: "video")
                {
                    urlVideo = vid
                }
            }
            
            if (urlVideo != nil)
            {
                self.setUpVideo(urlVideo: urlVideo!)
                self.setUpMute()
            }
            else
            {
                self.cleanLogo()
                self.setUpPageControl()
            }
            self.setUpClose()
       })
    }
    
    func setUpClose()
    {
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 12).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissVC(_:)))
        closeButton.addGestureRecognizer(tap)
    }
    
    func setUpMute()
    {
        view.addSubview(muteButton)
        muteButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 6).isActive = true
        muteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: (-18 - 18 - 28)).isActive = true
        muteButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        muteButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.muteVideo(_:)))
        muteButton.addGestureRecognizer(tap)
    }
    
    @objc func muteVideo(_ sender: UITapGestureRecognizer? = nil) {
        let vol = player.volume;
        if (vol == 0) {
            player.volume = 1;
            
            let image = UIImage.app( "icon_volume_on")
            muteButton.setImage(image, for: .normal)
        } else {
            player.volume = 0;
            
            let image = UIImage.app( "icon_volume_off")
            muteButton.setImage(image, for: .normal)
        }
        
    }
    
    func setUpLogo()
    {
        view.addSubview(logoBackgroundImage)
        //logoBackgroundImage.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 500).isActive = true
        //logoBackgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: (200)).isActive = true
        logoBackgroundImage.widthAnchor.constraint(equalToConstant: 220).isActive = true
        logoBackgroundImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        logoBackgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoBackgroundImage.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func cleanLogo()
    {
        logoBackgroundImage.removeFromSuperview()
    }
    
    func setUpVideo(urlVideo:String)
    {
        let videoView = UIView()
        videoView.frame = view.frame
        //videoView.backgroundColor = .black
        view.addSubview(videoView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)

        let videoURL = URL(string: urlVideo)
        player =  AVPlayer(url: videoURL!)
        avPlayerLayer = AVPlayerLayer(player: player)
        //avPlayerLayer.videoGravity = AVLayerVideoGravity.resize
        avPlayerLayer.frame = self.view.bounds
        videoView.layer.addSublayer(avPlayerLayer)
        player.play()
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUpPageControl() {
        
        viewControllersList = OnboardingPageList.allCases.map({ return viewController(for: $0) })
        self.setViewControllers([viewControllersList[0]], direction: .forward, animated: true, completion: nil)
        
        
        view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -18).isActive = true
        pageControl.anchorCenterXToSuperview()
        
        pageControl.numberOfPages = viewControllersList.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .valueChanged)
    }
    
    @objc func dismissVC(_ sender: UITapGestureRecognizer? = nil) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func viewController(for page: OnboardingPageList) -> UIViewController {
        switch page {
        case .createAccount:
            return OnboardingCreateAccountViewController.create(delegate: self)
        case .sync:
            return OnboardingSyncViewController.create(delegate: self)
        case .report:
            return  OnboardingReportViewController.create(delegate: self)
        }
    }
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        let page = sender.currentPage
        self.setViewControllers([viewControllersList[page]], direction: .forward, animated: true, completion: nil)
    }
    
    let pageControl = UIPageControl()
    lazy var closeButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage.app( "Close")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = UIColor.app(.white)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var logoBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        
        let image = UIImage.app( "logo")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor.app(.white)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var muteButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage.app( "icon_volume_on")
        button.setImage(image, for: .normal)
        //button.imageView?.tintColor = UIColor.app(.white)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}

extension OnboardingRootViewController: OnboardingChildDelegate {
    func nextButtonPressed() {
        if currentIndex != (viewControllersList.count - 1) {
            self.setViewControllers([viewControllersList[currentIndex+1]], direction: .forward, animated: true, completion: nil)
            pageControl.currentPage = currentIndex
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension OnboardingRootViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0, viewControllersList.count > previousIndex else { return nil }
        
    
        return viewControllersList[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let nextIndex = currentIndex + 1
        guard viewControllersList.count != nextIndex, viewControllersList.count > nextIndex else { return nil }

        return viewControllersList[nextIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let index = viewControllersList.firstIndex(of: pageViewController.viewControllers!.first!) {
            pageControl.currentPage = index
        }
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllersList.count
    }
}
