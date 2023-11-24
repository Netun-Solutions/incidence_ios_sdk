//
//  ReportIDKViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import UIKit

class ReportIDKViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "ReportScene"
    private var viewModel: ReportIDKViewModel! { get { return baseViewModel as? ReportIDKViewModel }}

    @IBOutlet weak var insuraceImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: TextLabel!
    @IBOutlet weak var instructionsContainerView: UIView!
    @IBOutlet weak var beaconImageView: UIImageView!
    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var lightsImageView: UIImageView!
    @IBOutlet weak var lightsLabel: UILabel!
    @IBOutlet weak var chalecoImageView: UIImageView!
    @IBOutlet weak var chalecoLabel: UILabel!
    @IBOutlet weak var outImageView: UIImageView!
    @IBOutlet weak var outLabel: UILabel!
    
    @IBOutlet weak var cancelButton: TextButton!
    @IBOutlet weak var acceptButton: PrimaryButton!
   
    // MARK: - Lifecycle
    static func create(with viewModel: ReportIDKViewModel) -> ReportIDKViewController {
        let view = ReportIDKViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppNavigation.setupNavigationApperance(navigationController!, with: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppNavigation.setupNavigationApperance(navigationController!, with: .regular)
    }
    
    
    override func setUpUI() {
        super.setUpUI()
        insuraceImageView.layer.cornerRadius = 36
        insuraceImageView.layer.masksToBounds = true
        insuraceImageView.image = UIImage.app( "Name=AXA")
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        
        instructionsContainerView.backgroundColor = UIColor.app(.incidence300b)
        instructionsContainerView.layer.cornerRadius = 8
        instructionsContainerView.layer.masksToBounds = true
        
        beaconImageView.image = viewModel.balizaImage
        beaconImageView.tintColor = UIColor.app(.incidence600)
        beaconLabel.text = viewModel.balizaText
        beaconLabel.textColor = UIColor.app(.incidence600)
        beaconLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        lightsImageView.image = viewModel.lightImage
        lightsImageView.tintColor = UIColor.app(.incidence600)
        lightsLabel.text = viewModel.lightText
        lightsLabel.textColor = UIColor.app(.incidence600)
        lightsLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        chalecoImageView.image = viewModel.chalecoImage
        chalecoImageView.tintColor = UIColor.app(.incidence600)
        chalecoLabel.text = viewModel.chalecoText
        chalecoLabel.textColor = UIColor.app(.incidence600)
        chalecoLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        outImageView.image = viewModel.outImage
        outImageView.tintColor = UIColor.app(.incidence600)
        outLabel.text = viewModel.outText
        outLabel.textColor = UIColor.app(.incidence600)
        outLabel.font = UIFont.app(.primarySemiBold, size: 16)
        
        acceptButton.setTitle(viewModel.acceptButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)
    }
 
    @IBAction func acceptButtonPressed(_ sender: Any) {
        //let vm = ReportMapViewModel()
        //let vc = ReportMapViewController.create(with: vm)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


