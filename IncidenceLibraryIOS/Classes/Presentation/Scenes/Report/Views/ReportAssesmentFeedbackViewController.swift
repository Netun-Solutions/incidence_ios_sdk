//
//  ReportAssesmentFeedbackViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 2/6/21.
//

import UIKit

class ReportAssesmentFeedbackViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {

    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportAssesmentFeedbackViewModel! { get { return baseViewModel as? ReportAssesmentFeedbackViewModel }}

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var otherTextView: UITextView!
    @IBOutlet weak var acceptButton: PrimaryButton!
    @IBOutlet weak var textViewContainerView: UIView!
    @IBOutlet weak var cancelButton: TextButton!
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportAssesmentFeedbackViewModel) -> ReportAssesmentFeedbackViewController {
        let bundle = Bundle(for: Self.self)
        let view = ReportAssesmentFeedbackViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        acceptButton.setTitle(viewModel.continueText, for: .normal)
        otherTextView.font = UIFont.app(.primaryRegular, size: 16)
        otherTextView.textColor = UIColor.app(.black300)
        otherTextView.delegate = self
        otherTextView.text = viewModel.placeholderText
        textViewContainerView.backgroundColor = UIColor.app(.white)
        textViewContainerView.layer.cornerRadius = 4
        textViewContainerView.layer.masksToBounds = true
        
        setUpKeyboardObservers()
        setUpHideKeyboardOnTap()
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        
        if let idIncidence = viewModel.incidence.id, let rateIncidence = viewModel.incidence.rate {
            showHUD()
            Api.shared.rateIncidence(incidenceId: String(idIncidence), rate: String(rateIncidence), rateComment: otherTextView.text, customAnswer: viewModel.customAnswer, answers: viewModel.answers, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    EventNotification.post(code: .INCIDENCE_REPORTED)
                    
                    let vm = ReportAssesmentSuccessViewModel()
                    let vc = ReportAssesmentSuccessViewController.create(with: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    self.onBadResponse(result: result)
                }
           })
        }
    }
}

extension ReportAssesmentFeedbackViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if otherTextView.textColor == UIColor.app(.black300) && otherTextView.isFirstResponder {
            otherTextView.text = nil
            otherTextView.textColor = UIColor.app(.black600)
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if otherTextView.text.isEmpty || otherTextView.text == "" {
            otherTextView.textColor = UIColor.app(.black300)
            otherTextView.text = viewModel.placeholderText
        }
    }
}
