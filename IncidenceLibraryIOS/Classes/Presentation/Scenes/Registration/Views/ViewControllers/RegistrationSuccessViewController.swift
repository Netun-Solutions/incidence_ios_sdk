//
//  RegistrationSuccessViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit

class RegistrationSuccessViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "RegistrationScene"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkOneImageView: UIImageView!
    @IBOutlet weak var personalDataLabel: TextLabel!
    @IBOutlet weak var carAndInsuranceLabel: TextLabel!
    @IBOutlet weak var checkTwoImageView: UIImageView!
    @IBOutlet weak var syncLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var checkThirdImageView: UIImageView!
    
    private var viewModel: RegistrationSuccessViewModel! { get { return baseViewModel as? RegistrationSuccessViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationSuccessViewModel) -> RegistrationSuccessViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationSuccessViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
        })?.removeFromSuperview()
    }
    
    override func setUpUI() {
        super.setUpUI()
        titleLabel.text = viewModel.titleLabelText
        personalDataLabel.text = viewModel.personalDataLabelText
        carAndInsuranceLabel.text = viewModel.carAndInsuranceLabelText
        syncLabel.text = viewModel.syncLabelText
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.invertedColors = true
        
        setUpRoundViews()
    }
    
    private func setUpRoundViews() {
        checkOneImageView.image = UIImage.app( "CheckCircleLine")?.withRenderingMode(.alwaysTemplate)
        checkOneImageView.tintColor = UIColor.app(.white)
        
        checkTwoImageView.image = UIImage.app( "CheckCircleLine")?.withRenderingMode(.alwaysTemplate)
        checkTwoImageView.tintColor = UIColor.app(.white)
        
        checkThirdImageView.image = UIImage.app( "CheckCircleLine")?.withRenderingMode(.alwaysTemplate)
        checkThirdImageView.tintColor = UIColor.app(.white)
    }


    @IBAction func continueButtonPressed(_ sender: Any) {
        Core.shared.showContent()
    }

}
