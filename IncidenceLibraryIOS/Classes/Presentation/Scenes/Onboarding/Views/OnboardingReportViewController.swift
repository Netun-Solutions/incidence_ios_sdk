//
//  OnboardingReportViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 27/4/21.
//

import UIKit

class OnboardingReportViewController: UIViewController, StoryboardInstantiable {
    
    
    static var storyboardFileName = "OnboardingScene"
    weak var delegate: OnboardingChildDelegate?
    
    @IBOutlet weak var nextButton: PrimaryButton!
    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var subtitleLabel: TextLabel!
    
    // MARK: - Lifecycle
    static func create(delegate: OnboardingChildDelegate) -> OnboardingReportViewController {
        let view = OnboardingReportViewController.instantiateViewController()
        view.delegate = delegate
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        titleLabel.text = "welcome_slide_3_title".localized()
        subtitleLabel.text = "welcome_slide_3_subtitle".localized()
        nextButton.setTitle("create_account".localized(), for: .normal)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        delegate?.nextButtonPressed()
    }
}
