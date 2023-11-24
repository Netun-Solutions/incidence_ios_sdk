//
//  AccountMyDataViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//


import UIKit

class AccountMyDataViewController: IABaseViewController, StoryboardInstantiable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextFieldView: FieldView!
    @IBOutlet weak var mobileTextFieldView: FieldView!
    @IBOutlet weak var IDTextFieldView: FieldView!
    @IBOutlet weak var datebirthTextFieldView: FieldView!
    @IBOutlet weak var emailTextFieldView: FieldView!
    @IBOutlet weak var appVersionTextFieldView: FieldView!
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    
    static var storyboardFileName = "AccountScene"
    private var viewModel: AccountMyDataViewModel! { get { return baseViewModel as? AccountMyDataViewModel }}
    

    
    // MARK: - Lifecycle
    static func create(with viewModel: AccountMyDataViewModel) -> AccountMyDataViewController {
        let view = AccountMyDataViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
    }
    
    override func setUpUI() {
        super.setUpUI()
        nameTextFieldView.configure(titleText: viewModel.fieldNameTitle)
        mobileTextFieldView.configure(titleText: viewModel.fieldPhoneTitle)
        emailTextFieldView.configure(titleText: viewModel.fieldEmailTitle)
        IDTextFieldView.configure(titleText: viewModel.fieldIDTitle)
        datebirthTextFieldView.configure(titleText: viewModel.fieldDatebirthTitle)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appVersionNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        appVersionTextFieldView.configure(titleText: "version_app".localized(),  valueText: String.init(format: "%@ (%@)", appVersion ?? "", appVersionNumber ?? ""))
    }
    
    override func loadData() {
        
        let user = Core.shared.getUser()
        
        nameTextFieldView.setText(user?.name ?? "")
        mobileTextFieldView.setText(user?.phone ?? "")
        
        if let phone = user?.phone {
            let formatted = phone.separate(every:3, with: " ")
            mobileTextFieldView.setText(formatted)
        }
        
        emailTextFieldView.setText(user?.email ?? "")
        IDTextFieldView.setText(user?.dni ?? "")
        if let cumple = user?.birthday, cumple.count > 0 {
            datebirthTextFieldView.setText(cumple)
        } else {
            datebirthTextFieldView.setText("-")
        }
        
        if (user?.birthday == nil)
        {
            datebirthTextFieldView.setTooltipText("include_birthday_to_complete".localized())
        }
        else
        {
            datebirthTextFieldView.removeTooltipText()
        }
    }
    
    override func reloadData() {
        loadData()
    }
    
    private func setUpNavigation() {
        let editButton = UIBarButtonItem(image: UIImage.app( "icon_edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editPressed))
        editButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editPressed() {
        let vm = AccountMyDataEditViewModel()
        let vc = AccountMyDataEditViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
