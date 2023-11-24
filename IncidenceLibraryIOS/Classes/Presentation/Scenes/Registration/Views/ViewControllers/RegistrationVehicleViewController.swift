//
//  RegistrationVehicleViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit
import Kingfisher

class RegistrationVehicleViewController: IABaseViewController, StoryboardInstantiable {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var stackView: UIStackView!
    

    private var viewModel: RegistrationVehicleViewModel! { get { return baseViewModel as? RegistrationVehicleViewModel }}

    let stepperView = StepperView()
    
    var vehicleTypes = [VehicleType]()
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationVehicleViewModel) -> RegistrationVehicleViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationVehicleViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }

    override func setUpUI() {
        super.setUpUI()
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        guard let types = Core.shared.getVehiclesTypes() else { return }
        vehicleTypes = types
        
        for (index, type) in vehicleTypes.enumerated() {
            
            if index % 2 == 0 {
                let view = UIView()
                view.backgroundColor = .clear
                view.translatesAutoresizingMaskIntoConstraints = false
                
                let internalStackView = UIStackView()
                internalStackView.axis = .horizontal
                internalStackView.spacing = 40
                
                view.addSubview(internalStackView)
                internalStackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0)
                internalStackView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: 0).isActive = true
                
                stackView.addArrangedSubview(view)
            }
            
            let button = UIButton()
            button.tag = index
            button.anchor(widthConstant: 120, heightConstant: 120)
            button.setTitle(nil, for: .normal)
            button.backgroundColor = UIColor.app(.white)
            button.layer.cornerRadius = 60
            button.layer.masksToBounds = true
            button.imageEdgeInsets = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
            
            if let urlString = type.colors?.first?.image, let imgURL = URL(string: urlString) {
                button.kf.setImage(with: imgURL, for: .normal)
            }

            let tapVehicle = UITapGestureRecognizer(target: self, action: #selector(self.vehicleTypePressed(_:)))
            button.addGestureRecognizer(tapVehicle)
    
            var arrangedViewIndex = Float(index) / 2
            arrangedViewIndex.round(.towardZero)
            
            if let stackView = stackView.arrangedSubviews[Int(arrangedViewIndex)].subviews[0] as? UIStackView {
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    private func setUpStepperView() {
        switch viewModel.origin {
        case .editVehicle, .add:
            stepperView.totalStep = 2
        case .addBeacon:
            stepperView.totalStep = 1
        default:
            stepperView.totalStep = 3
        }
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
            })?.removeFromSuperview()

        navigationController?.view.addSubview(stepperView)
            
        if let view = navigationController?.navigationBar {
            stepperView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            stepperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
            stepperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
            stepperView.anchorCenterXToSuperview()
            stepperView.currentStep = 2
            stepperView.percentatge = 15
        }
    }
    
    private func setUpButton(_ button: UIButton) {
        button.backgroundColor = UIColor.app(.white)
        button.layer.cornerRadius = 60
        button.layer.masksToBounds = true
        button.setTitle(nil, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
    }


    @objc func vehicleTypePressed(_ sender: UITapGestureRecognizer)
    {
        guard let button = sender.view as? UIButton else { return  }
        
        Core.shared.initVehicleCreating(viewModel.becomeFromAddBeacon)
        let vehicle = Core.shared.getVehicleCreating()
        vehicle.vehicleType = vehicleTypes[button.tag]
        
        let vm = RegistrationPlateViewModel(origin: viewModel.origin)
        let viewController = RegistrationPlateViewController.create(with: vm)
        navigationController?.pushViewController(viewController, animated: true)
    }

}

