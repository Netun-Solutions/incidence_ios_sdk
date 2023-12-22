//
//  ReportExpiredInsuranceViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import UIKit

class ReportExpiredInsuranceViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportExpiredInsuranceViewModel! { get { return baseViewModel as? ReportExpiredInsuranceViewModel }}

    
    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var instructionsContainerView: UIView!
    @IBOutlet weak var lightsImageView: UIImageView!
    @IBOutlet weak var lightsLabel: UILabel!
    @IBOutlet weak var chalecoImageView: UIImageView!
    @IBOutlet weak var chalecoLabel: UILabel!
    @IBOutlet weak var outImageView: UIImageView!
    @IBOutlet weak var outLabel: UILabel!
    
    @IBOutlet weak var cancelButton: TextButton!
    @IBOutlet weak var acceptButton: PrimaryButton!
   
    // MARK: - Lifecycle
    static func create(with viewModel: ReportExpiredInsuranceViewModel) -> ReportExpiredInsuranceViewController {
        let bundle = Bundle(for: Self.self)
        let view = ReportExpiredInsuranceViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppNavigation.setupNavigationApperance(navigationController!, with: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppNavigation.setupNavigationApperance(navigationController!, with: .regular)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func setUpUI() {
        super.setUpUI()

        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        
        instructionsContainerView.backgroundColor = UIColor.app(.incidence300b)
        instructionsContainerView.layer.cornerRadius = 8
        instructionsContainerView.layer.masksToBounds = true
        
        lightsImageView.image = viewModel.lightImage
        lightsImageView.tintColor = UIColor.app(.incidence600)
        lightsLabel.text = viewModel.lightText
        lightsLabel.textColor = UIColor.app(.incidence600)
        lightsLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        chalecoImageView.image = viewModel.chalecoImage
        chalecoImageView.tintColor = UIColor.app(.incidence600)
        chalecoLabel.text = viewModel.chalecoText
        chalecoLabel.textColor = UIColor.app(.incidence600)
        chalecoLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        outImageView.image = viewModel.outImage
        outImageView.tintColor = UIColor.app(.incidence600)
        outLabel.text = viewModel.outText
        outLabel.textColor = UIColor.app(.incidence600)
        outLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        acceptButton.setTitle(viewModel.acceptButtonText, for: .normal)
    }
 
    @IBAction func acceptButtonPressed(_ sender: Any) {
        /*
        let vmh = HomeViewModel()
        let vch = HomeViewController.create(with: vmh)
        
        let vm = AccountViewModel()
        let vc = AccountViewController.create(with: vm)
        navigationController?.setViewControllers([vch, vc], animated: true)
         */
    }
}


