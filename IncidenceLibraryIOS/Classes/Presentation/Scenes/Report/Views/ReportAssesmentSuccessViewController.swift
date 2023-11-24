//
//  ReportAssesmentSuccessViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 2/6/21.
//

import UIKit

class ReportAssesmentSuccessViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "ReportScene"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    
    private var viewModel: ReportAssesmentSuccessViewModel! { get { return baseViewModel as? ReportAssesmentSuccessViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportAssesmentSuccessViewModel) -> ReportAssesmentSuccessViewController {
        let view = ReportAssesmentSuccessViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.descriptionText
        continueButton.setTitle(viewModel.continueText, for: .normal)
        continueButton.invertedColors = true
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
