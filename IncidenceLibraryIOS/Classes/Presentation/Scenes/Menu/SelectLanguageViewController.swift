//
//  SelectLanguageViewController.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 11/5/22.
//

import UIKit

class SelectLanguageViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "MenuScene"
    
    var languages:[String] = ["lang_spanish".localized(), "lang_english".localized()]
    var languagesImage:[String] = ["flag_spanish", "flag_english"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var imgCloseIcon: UIImageView!
    

    static func create() -> SelectLanguageViewController {
        let view = SelectLanguageViewController.instantiateViewController()
        view.baseViewModel = IABaseViewModel()
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.estimatedRowHeight = LanguageCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        
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
    
    override func loadDataDelay() -> Bool {
        return true
    }
}


extension SelectLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.reuseIdentifier, for: indexPath) as? LanguageCell else {
            assertionFailure("Cannot dequeue reusable cell \(LanguageCell.self) with reuseIdentifier: \(LanguageCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.configure(with: languages[indexPath.row], imageModel: languagesImage[indexPath.row], showLine: indexPath.row < languages.count-1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var lang = "es"
        if (indexPath.row == 1)
        {
            lang = "en"
        }
        
        let current = Core.shared.getLanguage()
        
        if (current != lang)
        {
            Prefs.saveString(key: Constants.KEY_USER_LANG, value: lang)
            self.showHUD()
            //Api.shared.getGlobals(completion: { result in })
            Core.shared.getGeneralData();
            print("getGeneralData finished")
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DevicesCell.height
    }
}

