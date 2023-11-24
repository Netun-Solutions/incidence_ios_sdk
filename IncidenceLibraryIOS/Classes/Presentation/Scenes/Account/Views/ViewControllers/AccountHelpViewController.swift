//
//  AccountHelpViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import UIKit
import Alamofire

class HelpItem
{
    var title: String = ""
    var leftImage:String?
    var leftImageUrl:String?
    var rightImage:String?
    var object:Any?
}

class AccountHelpViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "AccountScene"
    private var viewModel: AccountHelpViewModel! { get { return baseViewModel as? AccountHelpViewModel }}
    
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var imgCloseIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let row_help = "row_help"
    let row_privacy = "row_privacy"
    let row_contact = "row_contact"
    let row_faqs = "row_faqs"
    let row_tutorial = "row_tutorial"
    
    var isHelpOpen = true
    var isTutorialOpen = false
    var items:[HelpItem] = [HelpItem]()
    var tutos:[TutorialVideo] = [TutorialVideo]()
    
    // MARK: - Lifecycle
    static func create(with viewModel: AccountHelpViewModel) -> AccountHelpViewController {
        let view = AccountHelpViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        self.view.backgroundColor = UIColor.app(.incidencePrimary)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = AccountHelpCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AccountHelpCell.self, forCellReuseIdentifier: AccountHelpCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        
        /*
        telephoneMenuView.configure(text: "contact_phone".localized(), iconImage: UIImage.app( "Phone"))
        telephoneMenuView.onTap { [weak self] in
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let firstAction: UIAlertAction = UIAlertAction(title: "call_to".localized() + Constants.PHONE_CONTACT , style: .default) { action -> Void in
                Core.shared.callNumber(phoneNumber: Constants.PHONE_CONTACT)
            }
            let image = UIImage.app( "PhoneBlack")?.withRenderingMode(.alwaysOriginal)
            firstAction.setValue(image, forKey: "image")

            let cancelAction: UIAlertAction = UIAlertAction(title: "cancel".localized(), style: .destructive) { action -> Void in }

            actionSheetController.addAction(firstAction)
            actionSheetController.addAction(cancelAction)

            self?.present(actionSheetController, animated: true, completion: nil)
        }
        
        //ocultamos
        telephoneMenuView.isHidden = true
        emailMenuView.topAnchor.constraint(equalTo: telephoneMenuView.topAnchor, constant: 0).isActive = true
        */
        
        
        
        /*
         
         xavi
         
        helpMenuView.configure(text: "help".localized(), color: MenuViewColors.white)
        helpMenuView.onTap { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.telephoneMenuView.isHidden = !strongSelf.telephoneMenuView.isHidden
            strongSelf.emailMenuView.isHidden = !strongSelf.emailMenuView.isHidden
            strongSelf.faqMenuView.isHidden = !strongSelf.faqMenuView.isHidden
     
            
            strongSelf.telephoneMenuView.heightAnchor.constraint(equalToConstant: 0)
            strongSelf.emailMenuView.heightAnchor.constraint(equalToConstant: 0)
            strongSelf.faqMenuView.heightAnchor.constraint(equalToConstant: 0)
        }
        
        
        telephoneMenuView.configure(text: "privacy".localized(), color: MenuViewColors.white, iconImage: UIImage.app( "Document"), iconImageColored: true)
        telephoneMenuView.onTap { [weak self] in
            
            
            guard let strongSelf = self else { return }
            let vm = RegistrationTermsViewModel()
            vm.onlyRead = true;
            let vc = RegistrationTermsViewController.create(with: vm)

            strongSelf.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        emailMenuView.configure(text: "contact_email".localized(), color: MenuViewColors.white, iconImage: UIImage.app( "Email"), iconImageColored: true)
        emailMenuView.onTap {
            let email = Constants.EMAIL_CONTACT
            if let url = URL(string: "mailto:\(email)") {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
              } else {
                UIApplication.shared.openURL(url)
              }
            }
        }
        
        faqMenuView.configure(text: "contact_faqs".localized(), color: MenuViewColors.white, iconImage: UIImage.app( "Question"), iconImageColored: true)
        faqMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            guard let url = URL(string: Constants.URL_FAQS) else { return }
            let vm = WebViewViewModel(title: "help".localized(), website: url)
            let vc = WebViewViewController(viewModel: vm)

            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
        
        tutorialMenuView.configure(text: "contact_tutorial".localized(), color: MenuViewColors.white, iconImage: UIImage.app( "ic_youtube"), iconImageColored: true)
        tutorialMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            
        }
         
         */

        imgClose.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTap(tapGestureRecognizer:)))
        imgClose.addGestureRecognizer(tapGesture)
        
        let image = UIImage.app( "Close")?.withRenderingMode(.alwaysTemplate)
        imgCloseIcon.image = image
        imgCloseIcon.tintColor = UIColor.app(.white)
        
    }
    
    @objc func userDidTap(tapGestureRecognizer: UITapGestureRecognizer) {
      // Your code goes here
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    
    override func loadData() {
        self.showHUD()
        Api.shared.getTutorialVideos(completion: { result in
            
            self.hideHUD()
            self.tutos.removeAll()
            
            if (result.isSuccess())
            {
                self.tutos = result.getList(key: "data") ?? [TutorialVideo]()
            }
            
            self.updateItems()
       })
    }
    
    
    func updateItems()
    {
        self.items.removeAll()
        
        let h1 = HelpItem()
        h1.title = "help".localized()
        h1.leftImage = nil
        h1.rightImage = isHelpOpen ? "up" : "down"
        h1.object = self.row_help
        self.items.append(h1)
        
        if (isHelpOpen)
        {
            let h2 = HelpItem()
            h2.title = "privacy".localized()
            h2.leftImage = "Document"
            h2.rightImage = "right"
            h2.object = self.row_privacy
            self.items.append(h2)
            
            let h3 = HelpItem()
            h3.title = "contact_email".localized()
            h3.leftImage = "Email"
            h3.rightImage = "right"
            h3.object = self.row_contact
            self.items.append(h3)
            
            let h4 = HelpItem()
            h4.title = "contact_faqs".localized()
            h4.leftImage = "Question"
            h4.rightImage = "right"
            h4.object = self.row_faqs
            self.items.append(h4)
        }
        
        
        let h5 = HelpItem()
        h5.title = "contact_tutorial".localized()
        h5.leftImage = "ic_youtube"
        h5.rightImage = isTutorialOpen ? "up" : "down"
        h5.object = self.row_tutorial
        self.items.append(h5)
        
        if (isTutorialOpen)
        {
            for tu in self.tutos {
                
                
                let h6 = HelpItem()
                h6.title = tu.title ?? ""
                h6.leftImageUrl = tu.img
                h6.rightImage = nil
                h6.object = tu
                self.items.append(h6)
            }
        }
        
        self.tableView.reloadData()
    }
}





extension AccountHelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountHelpCell.reuseIdentifier, for: indexPath) as? AccountHelpCell else {
            assertionFailure("Cannot dequeue reusable cell \(AccountHelpCell.self) with reuseIdentifier: \(AccountHelpCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        
        let it = self.items[indexPath.row]
        var arrow = MenuViewRightIcon.arrow
        if (it.rightImage == nil) {
            arrow = MenuViewRightIcon.none
        }
        else if (it.rightImage == "up") {
            arrow = MenuViewRightIcon.arrowUp
        }
        else if (it.rightImage == "down") {
            arrow = MenuViewRightIcon.arrowDown
        }
        
     
        cell.configure(with: it.title, leftIcon: it.leftImage, leftImageUrl: it.leftImageUrl, rightIcon: arrow, showLine: indexPath.row < items.count-1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let model = viewModel.activeSessions[indexPath.row]
        
        let it = self.items[indexPath.row]
        
        if let obj = it.object {
            
            
            if obj is TutorialVideo {
                
                let tu = obj as! TutorialVideo
                
                //guard let url = URL(string: tu.url ?? "") else { return }
                //let vm = WebViewViewModel(title: tu.title ?? "", website: url)
                //let vc = WebViewViewController(viewModel: vm)

                //self.navigationController?.pushViewController(vc, animated: true)
                
                /*
                guard let code = tu.code else { return }
                //var videoView: YTPlayerView!
                let videoView = YTPlayerView()
                videoView.delegate = self
                //videoView.load(withVideoId: code, playerVars: ["playsinline":"0", "modestbranding":"0", "version":"5"])
                //videoView.playVideo()
                
                videoView.loadVideo(byId: code, startSeconds: 0);
                 */
                guard let code = tu.code else { return }
                let vm = YoutubeViewModel(title: tu.title ?? "", code: code)
                let vc = YoutubeViewController(viewModel: vm)

                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            else if obj is String {
                
                let idRow = obj as! String
                
                if (idRow == self.row_help)
                {
                    isHelpOpen = !isHelpOpen
                    self.updateItems()
                }
                else if (idRow == self.row_tutorial)
                {
                    isTutorialOpen = !isTutorialOpen
                    self.updateItems()
                }
                else if (idRow == self.row_privacy)
                {
                    let vm = RegistrationTermsViewModel()
                    vm.onlyRead = true;
                    let vc = RegistrationTermsViewController.create(with: vm)

                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if (idRow == self.row_contact)
                {
                    let email = Constants.EMAIL_CONTACT
                    if let url = URL(string: "mailto:\(email)") {
                      if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                      } else {
                        UIApplication.shared.openURL(url)
                      }
                    }
                }
                else if (idRow == self.row_faqs)
                {
                    var urlStr = "faqs_url".localized()
                    if ("" == urlStr) {
                        urlStr = Constants.URL_FAQS;
                    }
                    
                    guard let url = URL(string: urlStr) else { return }
                    let vm = WebViewViewModel(title: "help".localized(), website: url)
                    let vc = WebViewViewController(viewModel: vm)

                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AccountHelpCell.height
    }
}
