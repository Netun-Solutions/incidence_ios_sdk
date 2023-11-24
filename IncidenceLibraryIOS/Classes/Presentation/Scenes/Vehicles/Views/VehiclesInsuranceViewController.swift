//
//  VehiclesInsuranceViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import UIKit

class VehiclesInsuranceViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insuranceFieldView: FieldView!
    @IBOutlet weak var idInsuranceFieldView: FieldView!
    @IBOutlet weak var idOwnerFieldView: FieldView!
    @IBOutlet weak var expirationFieldView: FieldView!
    
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesInsuranceViewModel! { get { return baseViewModel as? VehiclesInsuranceViewModel }}
    

    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesInsuranceViewModel) -> VehiclesInsuranceViewController {
        let view = VehiclesInsuranceViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .VEHICLE_UPDATED, selector: #selector(vehicleUpdated))
    }
    
    override func setUpUI() {
        super.setUpUI()
        insuranceFieldView.configure(titleText: viewModel.insuranceFieldViewTitle)
        idInsuranceFieldView.configure(titleText: viewModel.idInsuranceFieldViewTitle)
        idOwnerFieldView.configure(titleText: viewModel.idOwnerFieldViewTitle)
        expirationFieldView.configure(titleText: viewModel.expirationFieldViewTitle)
        
        setUpNavigation()
    }
    
    override func loadData() {
        insuranceFieldView.setText(viewModel.vehicle.insurance?.name ?? "")
        idInsuranceFieldView.setText(viewModel.vehicle.policy?.policyNumber ?? "")
        idOwnerFieldView.setText(viewModel.vehicle.policy?.dni ?? "")
        expirationFieldView.setText(DateUtils.dateStringInternationalToSpanish(viewModel.vehicle.policy?.policyEnd))
        
        /*
        if (viewModel.vehicle.policy?.policyEnd == nil)
        {
            expirationFieldView.setTooltipText("caducity_insurance_date_near".localized())
        }
        else
        {*/
            expirationFieldView.removeTooltipText()
        //}
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
        let vm = VehiclesInsuranceEditViewModel(vehicle: viewModel.vehicle)
        let vc = VehiclesInsuranceEditViewController.create(with: vm)
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
