//
//  ReportAssesmentBadFeedbackViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import UIKit

class ReportAssesmentBadFeedbackViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {

    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportAssesmentBadFeedbackViewModel! { get { return baseViewModel as? ReportAssesmentBadFeedbackViewModel }}

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var technicalCheckButton: CheckboxButton!
    @IBOutlet weak var technicalLabel: TextLabel!
    @IBOutlet weak var appCheckButton: CheckboxButton!
    @IBOutlet weak var appLabel: TextLabel!
    @IBOutlet weak var waitingCheckButton: CheckboxButton!
    @IBOutlet weak var waitingLabel: TextLabel!
    @IBOutlet weak var otherCheckButton: CheckboxButton!
    @IBOutlet weak var otherLabel: TextLabel!
    @IBOutlet weak var otherTextView: UITextView!
    @IBOutlet weak var otherFieldContainerView: UIView!
    @IBOutlet weak var otherContainerView: UIView!
    @IBOutlet weak var acceptButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    @IBOutlet weak var otherTitleLabel: TextLabel!
    
    // MARK: - Lifecycle
    static func create(with viewModel: ReportAssesmentBadFeedbackViewModel) -> ReportAssesmentBadFeedbackViewController {
        let bundle = Bundle(for: Self.self)
        let view = ReportAssesmentBadFeedbackViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0)
        
        for (index, answer) in viewModel.answers.enumerated() {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let checkboxButton = CheckboxButton(type: .custom)
            checkboxButton.configure()
            checkboxButton.tag = index
            let tapCheckbox = UITapGestureRecognizer(target: self, action: #selector(self.checkboxButtonPressed(_:)))
            checkboxButton.addGestureRecognizer(tapCheckbox)
            
            
            let label = UILabel()
            label.font = UIFont.app(.primaryRegular, size: 14)
            label.textColor = UIColor.app(.black600)
            label.numberOfLines = 0
            label.text = answer.name
            label.textAlignment = .left
            
            view.addSubview(checkboxButton)
            view.addSubview(label)
            
            checkboxButton.anchor(top: view.topAnchor, left: view.leftAnchor, topConstant: 0, leftConstant: 0, widthConstant: 24, heightConstant: 24)
            label.anchor(top: view.topAnchor, left: checkboxButton.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 4, leftConstant: 24, bottomConstant: 0, rightConstant: 0)
            
            stackView.insertArrangedSubview(view, at: index)
        }
        
        otherTitleLabel.text = viewModel.otherTitleText
        otherTextView.text = viewModel.otherPlaceholderText
        acceptButton.setTitle(viewModel.continueText, for: .normal)
        cancelButton.setTitle(viewModel.laterText, for: .normal)
        
        otherTextView.font = UIFont.app(.primaryRegular, size: 16)
        otherTextView.textColor = UIColor.app(.black300)
        otherTextView.delegate = self
        
        otherFieldContainerView.backgroundColor = UIColor.app(.white)
        otherFieldContainerView.layer.cornerRadius = 4
        otherFieldContainerView.layer.masksToBounds = true
        
        otherContainerView.isHidden = true
        
        setUpKeyboardObservers()
        setUpHideKeyboardOnTap()
    }

    @objc func checkboxButtonPressed(_ sender : UIGestureRecognizer) {
        guard let button = sender.view as? CheckboxButton else { return }
        button.isSelected = !button.isSelected
        button.updateCheckbox()
        if (button.tag + 1) == viewModel.answers.count {
            otherContainerView.isHidden = !button.isSelected
        }
        guard let idAnswer = viewModel.answers[button.tag].id else { return }
        
        if (button.isSelected)
        {
            if (!viewModel.responseAnswers.contains(idAnswer)) {
                viewModel.responseAnswers.append(idAnswer)
            }
        }
        else
        {
            if let index = viewModel.responseAnswers.firstIndex(of: idAnswer) {
                viewModel.responseAnswers.remove(at: index)
            }
        }
    }

    @IBAction func acceptButtonPressed(_ sender: Any) {
        
        if let incidende = viewModel.incidence {
            let vm = ReportAssesmentFeedbackViewModel(incidence: incidende, answers: self.viewModel.responseAnswers, customAnswer: otherTextView.text)
            let vc = ReportAssesmentFeedbackViewController.create(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        /*
        var hasDetail = false
        for vc in self.navigationController!.viewControllers {
            if vc is IncidencesDetailViewController {
                hasDetail = true
                break
            }
        }
        for vc in self.navigationController!.viewControllers {
            // Filter for your desired view controller:
            
            if vc is IncidencesDetailViewController {
                self.navigationController?.popToViewController(vc,animated:true)
                break
            }
            //else if vc is HomeViewController && !hasDetail {
            //    self.navigationController?.popToViewController(vc,animated:true)
            //    break
            //}
        }
        */
    }
}

extension ReportAssesmentBadFeedbackViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if otherTextView.textColor == UIColor.app(.black300) && otherTextView.isFirstResponder {
            otherTextView.text = nil
            otherTextView.textColor = UIColor.app(.black600)
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if otherTextView.text.isEmpty || otherTextView.text == "" {
            otherTextView.textColor = UIColor.app(.black300)
            otherTextView.text = viewModel.otherPlaceholderText
        }
    }
}
