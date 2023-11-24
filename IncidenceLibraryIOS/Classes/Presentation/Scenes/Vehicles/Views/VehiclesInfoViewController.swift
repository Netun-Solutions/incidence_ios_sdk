//
//  VehiclesInfoViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import UIKit

class VehiclesInfoViewController: IABaseViewController, StoryboardInstantiable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var plateFieldView: FieldView!
    @IBOutlet weak var yearFieldView: FieldView!
    @IBOutlet weak var brandFieldView: FieldView!
    @IBOutlet weak var modelFieldView: FieldView!
    @IBOutlet weak var colorFieldView: FieldView!
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?

    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesInfoViewModel! { get { return baseViewModel as? VehiclesInfoViewModel }}
    

    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesInfoViewModel) -> VehiclesInfoViewController {
        let view = VehiclesInfoViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .VEHICLE_UPDATED, selector: #selector(vehicleUpdated))
    }
    
    override func setUpUI() {
        super.setUpUI()
        plateFieldView.configure(titleText: viewModel.plateFieldViewTitle)
        yearFieldView.configure(titleText: viewModel.yearFieldViewTitle)
        brandFieldView.configure(titleText: viewModel.brandFieldViewTitle)
        modelFieldView.configure(titleText: viewModel.modelFieldViewTitle)
        colorFieldView.configure(titleText: viewModel.colorFieldViewTitle)
        
        setUpNavigation()
    }
    
    override func loadData() {
        plateFieldView.setText(viewModel.vehicle.licensePlate ?? "")
        if let year = viewModel.vehicle.registrationYear {
            yearFieldView.setText(String(year))
        }
        brandFieldView.setText(viewModel.vehicle.brand ?? "")
        modelFieldView.setText(viewModel.vehicle.model ?? "")
        
        if let color = viewModel.vehicle.color {
            colorFieldView.setText(color.name ?? "")
        } else {
            colorFieldView.setText("")
        }
    }
    
    private func setUpNavigation() {
        
        if (Core.shared.isUserPrimaryForVehicle(viewModel.vehicle))
        {
            let editButton = UIBarButtonItem(image: UIImage.app( "icon_edit")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editPressed))
            editButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
            navigationItem.rightBarButtonItem = editButton
        }
        else
        {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func editPressed() {
        let vm = VehiclesInfoEditViewModel(vehicle: viewModel.vehicle)
        let vc = VehiclesInfoEditViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func vehicleUpdated(_ notification: Notification) {
        
        if let vehicle = notification.object as? Vehicle {
            if (vehicle.id == viewModel.vehicle.id) {
                viewModel.vehicle = vehicle
                loadData()
            }
        }
    }
    
}
