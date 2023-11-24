//
//  OnboardingCreateAccountViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 27/4/21.
//

import UIKit


class OnboardingCreateAccountViewController: UIViewController, StoryboardInstantiable {
    
    
    static var storyboardFileName = "OnboardingScene"
    weak var delegate: OnboardingChildDelegate?
    
    @IBOutlet weak var nextButton: PrimaryButton!
    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var subtitleLabel: TextLabel!
    
    // MARK: - Lifecycle
    static func create(delegate: OnboardingChildDelegate) -> OnboardingCreateAccountViewController {
        let view = OnboardingCreateAccountViewController.instantiateViewController()
        view.delegate = delegate
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        titleLabel.text = "welcome_slide_1_title".localized()
        subtitleLabel.text = "welcome_slide_1_subtitle".localized()
        nextButton.setTitle("next".localized(), for: .normal)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        delegate?.nextButtonPressed()
    }
}
