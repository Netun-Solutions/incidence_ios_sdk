//
//  RegistrationTermsViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import UIKit

class RegistrationTermsViewController: IABaseViewController, StoryboardInstantiable {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var textLabel: InteractiveLinkLabel!
    @IBOutlet weak var firstCheckboxButton: CheckboxButton!
    @IBOutlet weak var firstCheckboxLabel: TextLabel!
    @IBOutlet weak var secondCheckboxButton: CheckboxButton!
    @IBOutlet weak var secondCheckboxLabel: TextLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainerView: UIView!
    
    private var viewModel: RegistrationTermsViewModel! { get { return baseViewModel as? RegistrationTermsViewModel }}

    let stepperView = StepperView()
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationTermsViewModel) -> RegistrationTermsViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationTermsViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (!viewModel.onlyRead)
        {
            setUpStepperView()
        }
    }

    override func setUpUI() {
        super.setUpUI()
        
        firstCheckboxLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        secondCheckboxLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        firstCheckboxLabel.text = viewModel.firstCheckboxText
        secondCheckboxLabel.text = viewModel.sendCheckboxText
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        
        textTitleLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        textTitleLabel.font = UIFont.app(.primarySemiBold, size: 16)
        textTitleLabel.text = ""
        textTitleLabel.isHidden = true
        
        
        if (viewModel.onlyRead) {
            textLabel.topAnchor.constraint(equalTo: textLabel.superview!.topAnchor, constant: 0).isActive = true
        } else {
            textLabel.topAnchor.constraint(equalTo: textLabel.superview!.topAnchor, constant: 24).isActive = true
        }
        
        textLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //textLabel.text = viewModel.contentText
        //textLabel.attributedText = viewModel.contentText.htmlAttributed(using: UIFont.app(.primaryRegular, size: 14)!)
        
        let font =  UIFont.app(.primaryRegular, size: 15)
        
        let formattedString = viewModel.contentText
                                .htmlAttributedString()
                                .with(font:font!)
        
        textLabel.attributedText = formattedString
        
        
        if (viewModel.onlyRead)
        {
            firstCheckboxLabel.isHidden = true
            firstCheckboxButton.isHidden = true
            secondCheckboxLabel.isHidden = true
            secondCheckboxButton.isHidden = true
            continueButton.isHidden = true
            bottomContainerView.isHidden = true
            
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        }
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
            stepperView.currentStep = 1
            stepperView.percentatge = 45
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        
        let user = Core.shared.getUserCreating()
        
        showHUD()
        Api.shared.signUp(name: user.name!, phone: user.phone!, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let vm = RegistrationValidationViewModel()
                let viewController = RegistrationValidationViewController.create(with: vm)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }

    @IBAction func checkboxButtonPressed(_ sender: Any) {
        continueButton.isEnabled = firstCheckboxButton.isSelected //&& secondCheckboxButton.isSelected
    }
}
