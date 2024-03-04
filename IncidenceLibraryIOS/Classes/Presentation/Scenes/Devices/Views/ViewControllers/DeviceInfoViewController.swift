//
//  DeviceInfoViewController.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 27/10/22.
//

import UIKit

class DeviceInfoViewController: IABaseViewController, StoryboardInstantiable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var backButton: PrimaryButton!
    @IBOutlet weak var findView: UIView!
    
    private var index: Int = 0
    
    let stepperView = StepperView()
    
    static var storyboardFileName = "DevicesScene"
    private var viewModel: DeviceDetailViewModel! { get { return baseViewModel as? DeviceDetailViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: DeviceDetailViewModel) -> DeviceInfoViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = DeviceInfoViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        titleLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        //let image = UIImage(named: "device_start")?.withRenderingMode(.alwaysTemplate)
        deviceImage.contentMode = .scaleAspectFit
        //deviceImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        if (viewModel.device.beaconType?.imageBeaconScreen1 != nil) {
            let imgURL = URL(string: viewModel.device.beaconType?.imageBeaconScreen1 ?? "")
            deviceImage.kf.setImage(with: imgURL)
        } else {
            let image = UIImage.app("device_info_1")
            deviceImage.image = image
        }
        
        if (viewModel.device.beaconType?.textBeaconScreen1 != nil) {
            titleLabel.text = viewModel.device.beaconType?.textBeaconScreen1;
        } else {
            titleLabel.text = "incidence_key_device_desc_info1".localized()
        }
        
        backButton.setTitle("incidence_key_continuar".localized(), for: .normal)
        backButton.addTarget(self, action: #selector(onClickReturn), for: .touchUpInside)
        
        setUpNavigation()
        
        IncidenceLibraryManager.shared.setViewBackground(view: self.view)
        IncidenceLibraryManager.shared.setButtonBackground(view: backButton)
        IncidenceLibraryManager.shared.setButtonTextColor(view: backButton)        
    }
    
    override func loadData() {
        
    }
    
    private func setUpNavigation() {
        
    }
    
    private func setUpStepperView() {
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
            })?.removeFromSuperview()

        navigationController?.view.addSubview(stepperView)
            
        if let view = navigationController?.navigationBar {
            stepperView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            stepperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
            stepperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
            stepperView.anchorCenterXToSuperview()
            stepperView.currentStep = 1
            stepperView.percentatge = 100
        }
    }
    
    @objc func onClickReturn() {
        if (index == 0) {
            index=1;
            
            if (viewModel.device.beaconType?.imageBeaconScreen2 != nil) {
                let imgURL = URL(string: viewModel.device.beaconType?.imageBeaconScreen2 ?? "")
                deviceImage.kf.setImage(with: imgURL)
            } else {
                let image = UIImage.app("device_info_2")
                deviceImage.image = image
            }
            
            if (viewModel.device.beaconType?.textBeaconScreen2 != nil) {
                titleLabel.text = viewModel.device.beaconType?.textBeaconScreen2;
            } else {
                titleLabel.text = "incidence_key_device_desc_info2".localized()
            }
            
            stepperView.currentStep = 2
            stepperView.percentatge = 100
            
        } else if (index == 1) {
            index=2
            
            if (viewModel.device.beaconType?.imageBeaconScreen3 != nil) {
                let imgURL = URL(string: viewModel.device.beaconType?.imageBeaconScreen3 ?? "")
                deviceImage.kf.setImage(with: imgURL)
            } else {
                let image = UIImage.app("device_info_3")
                deviceImage.image = image
            }
            
            if (viewModel.device.beaconType?.textBeaconScreen3 != nil) {
                titleLabel.text = viewModel.device.beaconType?.textBeaconScreen3;
            } else {
                titleLabel.text = "incidence_key_device_desc_info3".localized()
            }
            
            backButton.setTitle("Finalizar", for: .normal)
            
            stepperView.currentStep = 3
            stepperView.percentatge = 100
        } else {
            navigationController?.view.subviews.first(where: { (view) -> Bool in
                return view is StepperView
                })?.removeFromSuperview()
            backInfoPressed()
        }
    }
}
