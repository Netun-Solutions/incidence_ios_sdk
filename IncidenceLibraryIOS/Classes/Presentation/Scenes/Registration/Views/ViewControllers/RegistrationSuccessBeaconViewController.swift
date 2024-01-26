//
//  RegistrationSuccessBeaconViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import UIKit


class RegistrationSuccessBeaconViewController: IABaseViewController, StoryboardInstantiable {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var subtitleLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var imageBeacon: UIImageView!
    
    let stepperView = StepperView()
    

    
    private var viewModel: RegistrationSuccessBeaconViewModel! { get { return baseViewModel as? RegistrationSuccessBeaconViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationSuccessBeaconViewModel) -> RegistrationSuccessBeaconViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationSuccessBeaconViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }

    override func setUpUI() {
        super.setUpUI()
        titleLabel.text = viewModel.titleLabelText
        subtitleLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        subtitleLabel.text = viewModel.subtitleLabelText
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        
        let image = viewModel.beaconTypeId == 1 ? UIImage.app("location_smart") : viewModel.beaconTypeId == 3 ? UIImage.app("beacon_hella_reg") : UIImage.app("location")
        imageBeacon.image = image;
    }
  
    private func setUpStepperView() {
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
            })?.removeFromSuperview()

        navigationController?.view.addSubview(stepperView)
            
        if let view = navigationController?.navigationBar {
            stepperView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            stepperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
            stepperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
            stepperView.anchorCenterXToSuperview()
            stepperView.currentStep = 3
            stepperView.percentatge = 100
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        if viewModel.origin == .addBeacon {
            
            navigationController?.view.subviews.first(where: { (view) -> Bool in
                return view is StepperView
            })?.removeFromSuperview()
            AppNavigation.setupNavigationApperance(navigationController!, with: .transparent)
            
            self.dismiss(animated: false, completion: nil)
            
            let response: IActionResponse = IActionResponse(status: true)
            self.viewModel.delegate.onResult(response: response)
            
        } else {
            let vm = RegistrationSuccessViewModel()
            let viewController = RegistrationSuccessViewController.create(with: vm)
            navigationController?.setViewControllers([viewController], animated: true)
        }
    }
}

