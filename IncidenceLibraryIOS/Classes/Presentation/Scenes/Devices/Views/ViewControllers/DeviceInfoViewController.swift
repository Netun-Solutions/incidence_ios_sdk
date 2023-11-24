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
    
    static var storyboardFileName = "DevicesScene"
    private var viewModel: DeviceDetailViewModel! { get { return baseViewModel as? DeviceDetailViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: DeviceDetailViewModel) -> DeviceInfoViewController {
        let view = DeviceInfoViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        titleLabel.text = "device_desc_info1".localized()
        titleLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        //let image = UIImage.app( "device_start")?.withRenderingMode(.alwaysTemplate)
        let image = UIImage.app( "device_info_1")
        deviceImage.image = image
        deviceImage.contentMode = .scaleAspectFit
        //deviceImage.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.setTitle("continuar".localized(), for: .normal)
        backButton.addTarget(self, action: #selector(onClickReturn), for: .touchUpInside)
        
        setUpNavigation()
    }
    
    override func loadData() {
        
    }
    
    private func setUpNavigation() {
        
    }
    
    @objc func onClickReturn() {
        if (index == 0) {
            index=1;
            
            titleLabel.text = "device_desc_info2".localized()
            let image = UIImage.app( "device_info_2")
            deviceImage.image = image
        } else if (index == 1) {
            index=2
            
            titleLabel.text = "device_desc_info3".localized()
            let image = UIImage.app( "device_info_3")
            deviceImage.image = image
            
            backButton.setTitle("Finalizar", for: .normal)
        } else {
            backPressed()
        }
    }
}
