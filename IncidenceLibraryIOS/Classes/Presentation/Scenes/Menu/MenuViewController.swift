//
//  MenuViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 28/5/21.
//

import UIKit

class MenuViewController: UIViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "MenuScene"
    
    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var vehicleButton: UIButton!
    @IBOutlet weak var incidenceButton: UIButton!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    // MARK: - Lifecycle
    static func create() -> MenuViewController {
        let view = MenuViewController.instantiateViewController()
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        EventNotification.addObserver(self, code: .USER_UPDATED, selector: #selector(userUpdated))
    }
    
    private func setUpUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        accountButton.setTitle("account".localized(), for: .normal)
        accountButton.setImage(UIImage.app( "User")?.withRenderingMode(.alwaysTemplate), for: .normal)
        accountButton.tintColor = UIColor.app(.white)
        
        vehicleButton.setTitle("vehicles".localized(), for: .normal)
        vehicleButton.setImage(UIImage.app( "Property")?.withRenderingMode(.alwaysTemplate), for: .normal)
        vehicleButton.tintColor = UIColor.app(.white)
        
        incidenceButton.setTitle("incidences".localized(), for: .normal)
        incidenceButton.setImage(UIImage.app( "Warning")?.withRenderingMode(.alwaysTemplate), for: .normal)
        incidenceButton.tintColor = UIColor.app(.white)
        
        deviceButton.setTitle("devices".localized(), for: .normal)
        deviceButton.setImage(UIImage.app( "Dispositivo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        deviceButton.tintColor = UIColor.app(.white)
        
        buyButton.setTitle("buy_beacon".localized(), for: .normal)
        buyButton.setImage(UIImage.app( "icon_shop")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buyButton.tintColor = UIColor.app(.white)
        
        addButton.setTitle("add".localized(), for: .normal)
        addButton.setTitleColor(UIColor.app(.incidencePrimary), for: .normal)
        addButton.setImage(UIImage.app( "More"), for: .normal)
        addButton.tintColor = UIColor.app(.incidencePrimary)
        addButton.layer.cornerRadius = 25
        addButton.layer.masksToBounds = true
        addButton.backgroundColor = UIColor.app(.white)
        
        
        languageButton.setTitle("lang_spanish".localized(), for: .normal)
        languageButton.titleEdgeInsets = UIEdgeInsets(top: .leastNormalMagnitude, left: .leastNormalMagnitude, bottom: .leastNormalMagnitude, right: .leastNormalMagnitude)
        languageButton.contentEdgeInsets = UIEdgeInsets(top: .leastNormalMagnitude, left: .leastNormalMagnitude, bottom: .leastNormalMagnitude, right: .leastNormalMagnitude)
        languageButton.tintColor = UIColor.app(.white)
        
        
        helpButton.setTitle("help".localized(), for: .normal)
        helpButton.titleEdgeInsets = UIEdgeInsets(top: .leastNormalMagnitude, left: .leastNormalMagnitude, bottom: .leastNormalMagnitude, right: .leastNormalMagnitude)
        helpButton.contentEdgeInsets = UIEdgeInsets(top: .leastNormalMagnitude, left: .leastNormalMagnitude, bottom: .leastNormalMagnitude, right: .leastNormalMagnitude)
        helpButton.tintColor = UIColor.app(.white)
        
        
        stackView.setCustomSpacing(48, after: titleLabel)
        stackView.setCustomSpacing(48, after: buyButton)
        stackView.setCustomSpacing(48, after: addButton)
        
        //reviewXavi
        titleLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapLabel(tapGestureRecognizer:)))
        tapGesture.numberOfTapsRequired = 10
        titleLabel.addGestureRecognizer(tapGesture)

        
        
        printUserInfo()
    }
    
    @objc func userDidTapLabel(tapGestureRecognizer: UITapGestureRecognizer) {
      // Your code goes here
        let token:String? = Prefs.loadString(key: Constants.KEY_PUSH_ID)
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = token
    }
    
    func printUserInfo()
    {
        let user = Core.shared.getUser()
        let name = user?.alias ?? user?.name ?? ""
        titleLabel.text = String(format: "hola_nombre".localized(), name)
        
        let lang = Core.shared.getLanguage()
        if (lang == "en")
        {
            languageImageView.image = UIImage.app( "flag_english")
            languageButton.setTitle("lang_english".localized(), for: .normal)
        }
        else
        {
            languageImageView.image = UIImage.app( "flag_spanish")
            languageButton.setTitle("lang_spanish".localized(), for: .normal)
        }
    }
    
    @objc func userUpdated(_ notification: Notification) {
        
        printUserInfo()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        switch button {
        case accountButton:
            let vm = AccountViewModel()
            let viewController = AccountViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: false)
        case vehicleButton:
            let viewModel = VehiclesListViewModel()
            let viewController = VehiclesListViewController.create(with: viewModel)
            navigationController?.pushViewController(viewController, animated: false)
        case incidenceButton:
            let viewModel = IncidencesCarsListViewModel()
            let viewController = IncidencesCarsListViewController.create(with: viewModel)
            navigationController?.pushViewController(viewController, animated: false)
        case deviceButton:
            let viewModel = DeviceListViewModel()
            let viewController = DeviceListViewController.create(with: viewModel)
            navigationController?.pushViewController(viewController, animated: false)
        //case buyButton:
            //let viewModel = EcommerceViewModel()
            //let viewController = EcommerceVC.create(with: viewModel)
            //navigationController?.pushViewController(viewController, animated: false)
        case addButton:
            let viewModel = AddSelectionViewModel()
            let viewController = AddSelectionViewController.create(with: viewModel)
            navigationController?.pushViewController(viewController, animated: false)
        case languageButton:
            let viewController = SelectLanguageViewController.create()
            navigationController?.pushViewController(viewController, animated: false)
        case helpButton:
            let vm = AccountHelpViewModel()
            let vc = AccountHelpViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: false)
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}

public extension UINavigationController{
    func pushViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit() }
    
}
