//
//  AddSelectionViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 10/5/21.
//

import UIKit

class AddSelectionViewController: IABaseViewController, StoryboardInstantiable {

    static var storyboardFileName = "AddScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var beaconButton: UIButton!

    private var viewModel: AddSelectionViewModel! { get { return baseViewModel as? AddSelectionViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: AddSelectionViewModel) -> AddSelectionViewController {
        let view = AddSelectionViewController.instantiateViewController()
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
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        setUpButton(carButton)
        carButton.setImage(UIImage.app( "Car=Black"), for: .normal)
        setUpButton(beaconButton)
        beaconButton.setImage(UIImage.app( "beacon"), for: .normal)
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

    @IBAction func carButtonPressed(_ sender: Any) {
        let vm = RegistrationVehicleViewModel(origin: .add)
        vm.fromBeacon = false
        let viewController = RegistrationVehicleViewController.create(with: vm)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func beaconButtonPressed(_ sender: Any) {
        let vm = RegistrationBeaconViewModel(origin: .addBeacon)
        vm.fromBeacon = true
        let viewController = RegistrationBeaconSelectTypeViewController.create(with: vm)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

