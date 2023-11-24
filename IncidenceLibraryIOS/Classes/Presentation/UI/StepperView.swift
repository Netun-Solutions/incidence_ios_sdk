//
//  StepperView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import UIKit

class StepperView: UIView {
    
    @IBInspectable var currentStep: Int = 1
    var totalStep: Int = 3 {
        didSet {
            updateProgress()
        }
    }
    @IBInspectable var percentatge: Int = 0 {
        didSet {
            updateProgress()
        }
    }
    
    let firstStepView = UIView()
    let firstProgressView = UIView()
    let secondStepView = UIView()
    let secondProgressView = UIView()
    let thirdStepView = UIView()
    let thirdProgressView = UIView()
    let stackView = UIStackView()
    
    var progressConstraints: [NSLayoutConstraint] = []
    
    private lazy var elements: [UIView: UIView] = [firstStepView:firstProgressView, secondStepView:secondProgressView, thirdStepView:thirdProgressView]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpUI()
    }

    private func setUpUI() {
        self.backgroundColor = .clear
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 6
        
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        self.heightAnchor.constraint(equalToConstant: 11).isActive = true
        elements.enumerated().forEach { (index, element) in
            
            let stepView = element.key
            let progressView = element.value
            
            stepView.translatesAutoresizingMaskIntoConstraints = false
            progressView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(stepView)
            stepView.heightAnchor.constraint(equalToConstant: 3).isActive = true
            stepView.backgroundColor = UIColor.app(.incidence200)
            stepView.layer.cornerRadius = 1.5
            progressView.backgroundColor = UIColor.app(.incidencePrimary)
            progressView.layer.cornerRadius = 1.5
            stepView.addSubview(progressView)
            progressView.leftAnchor.constraint(equalTo: stepView.leftAnchor).isActive = true
            progressView.topAnchor.constraint(equalTo: stepView.topAnchor).isActive = true
            progressView.bottomAnchor.constraint(equalTo: stepView.bottomAnchor).isActive = true
            
        }
    }
    
    private func updateProgress() {
          
        elements.enumerated().forEach({ (index, element) in
            if currentStep > (index + 1) {
                element.value.widthAnchor.constraint(equalTo: element.key.widthAnchor, multiplier: 1).isActive = true
            } else if (index+1) == currentStep {
                let multiplier: CGFloat = CGFloat(percentatge) / 100.0
                element.value.widthAnchor.constraint(equalTo: element.key.widthAnchor, multiplier: multiplier).isActive = true
            }
        })
        
        while stackView.arrangedSubviews.count > totalStep {
            stackView.removeArrangedSubview(stackView.arrangedSubviews.first!)
        }
    }
}
