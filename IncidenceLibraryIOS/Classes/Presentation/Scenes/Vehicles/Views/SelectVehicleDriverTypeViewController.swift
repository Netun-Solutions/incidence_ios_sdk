//
//  SelectVehicleDriverTypeViewController.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 4/2/22.
//

import UIKit
 
class SelectVehicleDriverTypeViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: SelectVehicleDriverTypeViewModel! { get { return baseViewModel as? SelectVehicleDriverTypeViewModel }}
    
    @IBOutlet weak var driverPrimaryView: MenuView!
    @IBOutlet weak var driverSecondaryView: MenuView!
    
    @IBOutlet weak var lblTitle: TextLabel!
    @IBOutlet weak var lblCancel: TextLabel!
    
    var bottomSheetController: BottomSheetViewController?
    
    // MARK: - Lifecycle
    static func create(with viewModel: SelectVehicleDriverTypeViewModel) -> SelectVehicleDriverTypeViewController {
        let view = SelectVehicleDriverTypeViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
        })?.removeFromSuperview()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        driverPrimaryView.configure(text: "driver_primary".localized())
        driverPrimaryView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.showPrimaryDriverPopUp()
        }
        
        driverSecondaryView.configure(text: "driver_secondary".localized())
        driverSecondaryView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.showSecondaryDriverPopUp()
        }
        
        lblTitle.backgroundColor = .clear
        lblTitle.textColor = UIColor.app(.black600)
        lblTitle.font = UIFont.app(.primaryRegular, size: 16)
        lblTitle.text = "ask_type_driver_you_are".localized()
        
        
        lblCancel.backgroundColor = .clear
        lblCancel.textColor = UIColor.app(.incidence500)
        lblCancel.textAlignment = .center
        lblCancel.font = UIFont.app(.primarySemiBold, size: 16)
        lblCancel.text = "cancel".localized()
        lblCancel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        lblCancel.addGestureRecognizer(tap)
    }
    
    override func loadData() {
    }
    
    @objc private func onTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showPrimaryDriverPopUp()
    {
        let title = "ask_you_are_driver_primary".localized()
        let message = "ask_you_are_driver_primary_desc".localized()
        let identifier = "primary"
        
        let view = HomeBottomSheetView()
        view.configure(delegate: self, title: title, description: message, firstButtonText: "i_am_driver_primary".localized(), secondButtonText: "cancel".localized(), secondButtonTextColor: MenuViewColors.red, identifier: identifier)
      
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
        navigationController?.present(bottomSheetController!, animated: true, completion: nil)
    }
    
    private func showSecondaryDriverPopUp()
    {
        let title = "ask_you_are_driver_secondary".localized()
        let message = "ask_you_are_driver_secondary_desc".localized()
        let identifier = "secondary"
        
        let view = HomeBottomSheetView()
        view.configure(delegate: self, title: title, description: message, firstButtonText: "accept".localized(), secondButtonText: "cancel".localized(), secondButtonTextColor: MenuViewColors.red, identifier: identifier)
      
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
        navigationController?.present(bottomSheetController!, animated: true, completion: nil)
    }
    
    private func requestDriver(_ vehicleDriverType: String)
    {
        showHUD()
        Api.shared.requestAddVehicleDriver(vehicleId: viewModel.vehicleId, type: vehicleDriverType, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                //Finaliza el registro porque ese vehiculo ya existe.
                //Go home
                Core.shared.showContent()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
}

extension SelectVehicleDriverTypeViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        
        var vehicleDriverType = "0"
        if let identifier = identifier as? String, identifier == "primary" {
            vehicleDriverType = "1"
        }
        
        bottomSheetController?.dismiss(animated: true, completion: {
            self.requestDriver(vehicleDriverType)
        })
    }
    
    func secondButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: {
        })
    }
}
