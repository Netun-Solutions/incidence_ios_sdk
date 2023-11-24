//
//  ReportAssesmentViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 2/6/21.
//

import UIKit

class ReportAssesmentViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportAssesmentViewModel! { get { return baseViewModel as? ReportAssesmentViewModel }}

    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var slideContainerView: UIView!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var acceptButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportAssesmentViewModel) -> ReportAssesmentViewController {
        let view = ReportAssesmentViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
 
    
    override func setUpUI() {
        super.setUpUI()
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        acceptButton.setTitle(viewModel.continueText, for: .normal)
        cancelButton.setTitle(viewModel.laterText, for: .normal)
        
        slideContainerView.backgroundColor = UIColor.app(.white)
        slideContainerView.layer.cornerRadius = 4
        slideContainerView.layer.borderWidth = 1
        slideContainerView.layer.borderColor = UIColor.app(.incidence200)?.cgColor
        slideContainerView.layer.masksToBounds = true
        
        setUpSlider()
    }
    
    private func setUpSlider() {
        slider.minimumTrackTintColor = UIColor.app(.incidencePrimary)
        slider.value = 2
        slider.handleValueChange()
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
            
        if let incidence = viewModel.incidence, let idIncidence = incidence.id {
            let rate = Int(slider.value)
            showHUD()
            Api.shared.rateIncidence(incidenceId: String(idIncidence), rate: String(rate), rateComment: nil, customAnswer: nil, answers: nil, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    incidence.rate = rate
                    let answers:[Answer]? = result.getList(key: "answers")
                    
                    if (answers != nil && answers!.count > 0)
                    {
                        let vm = ReportAssesmentBadFeedbackViewModel(incidence: incidence, answers: answers!)
                        let vc = ReportAssesmentBadFeedbackViewController.create(with: vm)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        let vm = ReportAssesmentFeedbackViewModel(incidence: incidence, answers: nil, customAnswer: nil)
                        let vc = ReportAssesmentFeedbackViewController.create(with: vm)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else
                {
                    self.onBadResponse(result: result)
                }
           })
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
