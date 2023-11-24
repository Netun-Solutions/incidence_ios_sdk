//
//  RegistrationColorViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//


import UIKit
import Kingfisher
// import Hue

class RegistrationColorViewController: IABaseViewController, StoryboardInstantiable {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var laterButton: TextButton!
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    let stepperView = StepperView()
    
    var selectedColor: ColorType? = nil
    private var viewModel: RegistrationColorViewModel! { get { return baseViewModel as? RegistrationColorViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationColorViewModel) -> RegistrationColorViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationColorViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        view.selectedColor = viewModel.selectedColor
        
        return view
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (viewModel.origin != .editVehicle) {
            setUpStepperView()
        }
    }

    override func setUpUI() {
        super.setUpUI()
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        laterButton.setTitle(viewModel.laterButtonText, for: .normal)
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = selectedColor != nil
        
        if (selectedColor != nil)
        {
            if let url = URL(string: selectedColor!.image ?? "") {
                carImageView.kf.setImage(with: url)
            }
        }
        else if (viewModel.vehicleColors != nil && (viewModel.vehicleColors?.count ?? 0) > 0)
        {
            let color = viewModel.vehicleColors![0]
            if let url = URL(string: color.image ?? "") {
                carImageView.kf.setImage(with: url)
            }
        }
        
        setUpColors()
    }
    
    private func setUpColors() {
        stackView.removeAllArrangedSubviews()
      
        if (viewModel.vehicleColors != nil && (viewModel.vehicleColors?.count ?? 0) > 0)
        {
            for (index, type) in viewModel.vehicleColors!.enumerated() {
                
                if index % 4 == 0 {
                    let view = UIView()
                    view.backgroundColor = .clear
                    view.translatesAutoresizingMaskIntoConstraints = false
                    
                    let internalStackView = UIStackView()
                    internalStackView.axis = .horizontal
                    internalStackView.spacing = 24
                    
                    view.addSubview(internalStackView)
                    internalStackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0)
                    internalStackView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: 0).isActive = true
                    
                    stackView.addArrangedSubview(view)
                }
                
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.anchor(widthConstant: 48, heightConstant: 48)
                //view.backgroundColor = UIColor(hex: type.color ?? "")
                view.layer.cornerRadius = 24
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.app(.black300)?.cgColor
                
                if selectedColor != nil {
                    if type.id == selectedColor?.id {
                        view.layer.borderColor = UIColor.app(.incidence500)?.cgColor
                        view.layer.borderWidth = 3
                    } else {
                        view.alpha = 0.2
                    }
                }
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapColor(_:)))
                view.tag = index
                view.addGestureRecognizer(tap)
        
                var arrangedViewIndex = Float(index) / 4
                arrangedViewIndex.round(.towardZero)
                
                if let stackView = stackView.arrangedSubviews[Int(arrangedViewIndex)].subviews[0] as? UIStackView {
                    stackView.addArrangedSubview(view)
                }
            }
        }
    }
    
    @objc func handleTapColor(_ sender: UITapGestureRecognizer? = nil) {
        selectedColor =  viewModel.vehicleColors?[sender?.view?.tag ?? 0]
        setUpColors()
        
        if let url = URL(string: selectedColor?.image ?? "") {
            carImageView.kf.setImage(with: url)
        }
        stepperView.percentatge = 95
        
        continueButton.isEnabled = true
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
            stepperView.percentatge = 60
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        viewModel.selectedColor = selectedColor
        if viewModel.origin == .registration || viewModel.origin == .add {
            
            let vehicle = Core.shared.getVehicleCreating()
            vehicle.color = selectedColor
            
            self.addVehicle(vehicle: vehicle)
            
            
        } else if viewModel.origin == .editVehicle {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func laterButtonPressed(_ sender: Any) {
        if viewModel.origin == .registration || viewModel.origin == .add {
            /*
            let vm = RegistrationInsuranceViewModel(origin: viewModel.origin)
            let viewController = RegistrationInsuranceViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
            */
            
            //añadimos vehiculo sin color
            let vehicle = Core.shared.getVehicleCreating()
            
            self.addVehicle(vehicle: vehicle)
            
            
        } else if viewModel.origin == .editVehicle {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func addVehicle(vehicle:Vehicle)
    {
        showHUD()
        Api.shared.addVehicle(vehicle: vehicle, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let v:Vehicle? = result.get(key: "vehicle")
                vehicle.policy = v?.policy
                vehicle.id = v?.id
                
                EventNotification.post(code: .VEHICLE_ADDED, object: v)
                
                let vm = RegistrationInsuranceViewModel(origin: self.viewModel.origin)
                let viewController = RegistrationInsuranceViewController.create(with: vm)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
}

