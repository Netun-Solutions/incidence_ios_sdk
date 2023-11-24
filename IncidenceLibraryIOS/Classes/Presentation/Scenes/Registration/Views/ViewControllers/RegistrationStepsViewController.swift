//
//  RegistrationStepsViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//


import UIKit

class RegistrationStepsViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "RegistrationScene"
    
    @IBOutlet weak var buttonContraint: NSLayoutConstraint!
    
    @IBOutlet weak var roundOneView: UIView!
    @IBOutlet weak var oneLabel: TextLabel!
    @IBOutlet weak var personalDataLabel: TextLabel!
    
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var twoLabel: TextLabel!
    @IBOutlet weak var carAndInsuranceLabel: TextLabel!
    
    @IBOutlet weak var threeView: UIView!
    @IBOutlet weak var threeLabel: TextLabel!
    @IBOutlet weak var syncLabel: TextLabel!
    
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var signInLabel: TextLabel!
    @IBOutlet weak var signInButton: TextButton!
    
    var presentOnboarding: Bool = true
    
    private var viewModel: RegistrationStepsViewModel! { get { return baseViewModel as? RegistrationStepsViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationStepsViewModel) -> RegistrationStepsViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationStepsViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }

    override func viewWillAppear(_ animated: Bool) {
        forceShowBackButton = true
        super.viewWillAppear(animated)
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
        })?.removeFromSuperview()
        
        setUpRoundViews()
        
        if presentOnboarding, viewModel.presentOnboarding, viewModel.completedSteps.count == 0 {
            let onboarding = OnboardingRootViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            onboarding.modalPresentationStyle = .fullScreen
            self.present(onboarding, animated: false, completion: nil)
            presentOnboarding = false
        }
    }
    
    override func backPressed() {
        let onboarding = OnboardingRootViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        onboarding.modalPresentationStyle = .fullScreen
        self.present(onboarding, animated: true, completion: nil)
    }
    
    override func setUpUI() {
        super.setUpUI()
        personalDataLabel.text = viewModel.personalDataLabelText
        carAndInsuranceLabel.text = viewModel.carAndInsuranceLabelText
        syncLabel.text = viewModel.syncLabelText
        continueButton.setTitle(viewModel.createAccounButtonText, for: .normal)
        signInLabel.text = viewModel.signInLabelText
        signInButton.setTitle(viewModel.signInButtonText, for: .normal)
        
        if viewModel.completedSteps.count == 1 {
            buttonContraint.constant = -24
        }
    }
    
    private func setUpRoundViews() {
        roundOneView.layer.borderWidth = 1
        roundOneView.layer.cornerRadius = 12
        twoView.layer.borderWidth = 1
        twoView.layer.cornerRadius = 12
        threeView.layer.borderWidth = 1
        threeView.layer.cornerRadius = 12
        
        setUpColors(numberLabel: oneLabel, textLabel: personalDataLabel, roundView: roundOneView, success: viewModel.completedSteps.count > 0)
        setUpColors(numberLabel: twoLabel, textLabel: carAndInsuranceLabel, roundView: twoView, success: viewModel.completedSteps.count > 1)
        setUpColors(numberLabel: threeLabel, textLabel: syncLabel, roundView: threeView, success: viewModel.completedSteps.count > 2)
    }

    private func setUpColors(numberLabel: UILabel, textLabel: UILabel, roundView: UIView, success: Bool) {
        numberLabel.textColor = success ? UIColor.app(.success) : UIColor.app(.incidence600)
        textLabel.textColor = success ? UIColor.app(.success) : UIColor.app(.incidence600)
        roundView.layer.borderColor = success ? UIColor.app(.success)?.cgColor : UIColor.app(.incidence600)?.cgColor
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if viewModel.completedSteps.count == 0 {
            let vm = RegistrationNameViewModel()
            let viewController = RegistrationNameViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
        } else if viewModel.completedSteps.count == 1 {
            let vm = RegistrationVehicleViewModel(origin: viewModel.origin)
            let viewController = RegistrationVehicleViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
        } else if viewModel.completedSteps.count == 2 {
            let vm = RegistrationBeaconViewModel(origin: viewModel.origin)
            let viewController = RegistrationBeaconSelectTypeViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        if viewModel.completedSteps.count == 2 {
            let vm = RegistrationSuccessViewModel()
            let viewController = RegistrationSuccessViewController.create(with: vm)
            navigationController?.setViewControllers([viewController], animated: true)
        } else {
            let vm = SignInViewModel(viewType: .telephone)
            let viewController = SignInViewController.create(with: vm)
            navigationController?.setViewControllers([viewController], animated: false)
        }
    }
}
