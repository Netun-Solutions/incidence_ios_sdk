//
//  ReportIDKViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import UIKit

class ReportIDKViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return "report_incidence".localized() }
        set { }
    }

    let insuranceImage: UIImage? = UIImage.app( "Name=AXA")
    let descriptionText: String = "your_insurance_contact_you".localized()
    
    let balizaImage = UIImage.app( "Type=Yes")?.withRenderingMode(.alwaysTemplate)
    let balizaText = "incidence_tip_beacon".localized()
    
    let lightImage = UIImage.app( "Light")?.withRenderingMode(.alwaysTemplate)
    let lightText = "incidence_tip_lights".localized()
    
    let chalecoImage = UIImage.app( "Chaleco")?.withRenderingMode(.alwaysTemplate)
    let chalecoText = "incidence_tip_vest".localized()
    
    let outImage = UIImage.app( "Property")?.withRenderingMode(.alwaysTemplate)
    let outText = "incidence_tip_exit_car".localized()
    
    let acceptButtonText: String = "accept".localized()
    let cancelButtonText: String = "cancel".localized()
}
