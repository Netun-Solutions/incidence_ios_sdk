//
//  EcommerceVC.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 25/10/21.
//

import Foundation
import UIKit
import SafariServices

class EcommerceVC: IABaseViewController
{
    private var viewModel: EcommerceViewModel! { get { return baseViewModel as? EcommerceViewModel }}
    
    private let firstButton = PrimaryButton()
    private var pageController:UIPageViewController?
    private var items:[EcommerceItem] = [EcommerceItem]()
    private var currentIndex:Int = 0
    private var selectedItem:EcommerceItem?
    /*
    let pad: CGFloat = 25
    private var pageScrollView:UIScrollView?
    */
    static func create(with viewModel: EcommerceViewModel) -> EcommerceVC {
        let view = EcommerceVC()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.view.backgroundColor = UIColor.app(.incidence100)
        
        self.view.addSubview(firstButton)
        firstButton.anchor(left: view.leftAnchor, bottom: view.safeBottomAnchor, right: view.rightAnchor, leftConstant: 20, bottomConstant: 0, rightConstant: 20, heightConstant: 64)
        let tap = UITapGestureRecognizer(target: self, action: #selector(firstButtonPressed))
        firstButton.addGestureRecognizer(tap)
        
        self.setupPageController()
    }
    
    private func setupPageController()
    {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [EcommerceVC.self])
        appearance.pageIndicatorTintColor = UIColor.app(.grey300)
        appearance.currentPageIndicatorTintColor = UIColor.app(.incidence500)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        self.pageController?.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: firstButton.topAnchor, right: view.rightAnchor, topConstant: 60, leftConstant: 0, bottomConstant: 30, rightConstant: 0)
        
        
        /*
        pageScrollView = UIScrollView()
        pageScrollView?.isOpaque = false
        pageScrollView?.showsHorizontalScrollIndicator = false
        pageScrollView?.clipsToBounds = false
        pageScrollView?.isPagingEnabled = true
        pageScrollView?.delegate = self
            
        self.view.addSubview(self.pageScrollView!)
        self.pageScrollView?.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: firstButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0)
        */
    }
    
    override func loadData() {
        self.showHUD()
        Api.shared.getEcommercesSdk(vehicle: viewModel.vehicle, user: viewModel.user, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                self.items = result.getList(key: "items") ?? [EcommerceItem]()
                self.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    override func reloadData()
    {
        if (self.items.count > 0)
        {
            self.selectedItem = items[0]
            self.reloadButtonTitle()
            let initialVC = EcommercePageVC(index: 0, item: self.selectedItem!)
            self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
            self.pageController?.didMove(toParent: self)
        }
        
        //self.setViews()
    }
    
    func reloadButtonTitle()
    {
        if (self.selectedItem != nil) {
            if let title = self.selectedItem!.title_button {
                self.firstButton.setTitle(title, for: .normal)
            }
        }
    }
    
    @objc func firstButtonPressed() {
        if let item = self.selectedItem, let url = item.link {
            let config = SFSafariViewController.Configuration()
            let vc = SFSafariViewController(url: URL(string: url)!, configuration: config)
            self.present(vc, animated: true)
        }
    }
}

extension EcommerceVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? EcommercePageVC else {
            return nil
        }
        
        var index = currentVC.index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc: EcommercePageVC = EcommercePageVC(index:index, item:items[index])
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed)
        {
            guard let currentVC = pageViewController.viewControllers?.first as? EcommercePageVC else {
                return
            }
            
            self.selectedItem = currentVC.item
            self.reloadButtonTitle()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? EcommercePageVC else {
            return nil
        }
        
        var index = currentVC.index
        
        if index >= self.items.count - 1 {
            return nil
        }
        
        index += 1
        
        self.selectedItem = items[index]
        self.reloadButtonTitle()
        
        let vc: EcommercePageVC = EcommercePageVC(index: index, item: self.selectedItem!)
        
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.items.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}
/*
extension EcommerceVC: UIScrollViewDelegate {
    
    func removeViews()
    {
        if let scrollView = self.pageScrollView {
            for vi in scrollView.subviews {
                vi.removeFromSuperview()
            }
        }
    }
    
    func setViews()
    {
        let wi = CGFloat(pageScrollView?.frame.width ?? 1) - pad*2

        self.removeViews()
        
        for i in 0...items.count-1 {
            
            let it = self.items[i]
            
            let view = UIView(frame: self.pageScrollView?.bounds ?? .zero)
            view.backgroundColor = .purple
            
            
            let exis = (CGFloat(i) * wi) + pad
            let newWi = wi - pad/2
            setFrameX(myView: view, x: exis)
            setFrameW(myView: view, w: newWi)
        
            
           self.pageScrollView?.addSubview(view)
        }
        
        pageScrollView?.contentSize = CGSize(width: CGFloat(pageScrollView?.frame.width ?? 1) * CGFloat(items.count), height: CGFloat(pageScrollView?.frame.size.height ?? 1));
    }
    
    func setFrame(myView: UIView, x: CGFloat?, y: CGFloat?, w: CGFloat?, h: CGFloat?){
        var f = myView.frame

        if let safeX = x {
            f.origin = CGPoint(x: safeX, y: f.origin.y)
        }
        if let safeY = y {
            f.origin = CGPoint(x: f.origin.x, y: safeY)
        }
        if let safeW = w {
            f.size.width = safeW
        }
        if let safeH = h {
            f.size.height = safeH
        }

        myView.frame = f
    }

    func setFrameX(myView: UIView, x: CGFloat) {
        setFrame(myView: myView, x: x, y: nil, w: nil, h: nil)
    }
    func setFrameY(myView: UIView, y: CGFloat) {
        setFrame(myView: myView, x: nil, y: y, w: nil, h: nil)
    }
    func setFrameW(myView: UIView, w: CGFloat) {
        setFrame(myView: myView, x: nil, y: nil, w: w, h: nil)
    }
    func setFrameH(myView: UIView, h: CGFloat) {
        setFrame(myView: myView, x: nil, y: nil, w: nil, h: h)
    }

    func adjustFrame(f: CGRect, x: CGFloat?, y: CGFloat?, w: CGFloat?, h: CGFloat?) -> CGRect {
        var rect = f

        if let safeX = x {
            rect.origin = CGPoint(x: rect.origin.x + safeX, y: f.origin.y)
        }
        if let safeY = y {
            rect.origin = CGPoint(x: f.origin.x, y: rect.origin.y + safeY)
        }
        if let safeW = w {
            rect.size.width = safeW + rect.size.width
        }
        if let safeH = h {
            rect.size.height = safeH + rect.size.height
        }

        return rect
    }

    func adjustFrame(myView: UIView, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        myView.frame = adjustFrame(f: myView.frame, x: x, y: y, w: w, h: h);
    }
}
*/
