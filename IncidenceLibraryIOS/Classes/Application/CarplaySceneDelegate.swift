//
//  CarplaySceneDelegate.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 20/10/21.
//

import UIKit
import CarPlay

class CarplaySceneDelegate : UIResponder, CPTemplateApplicationSceneDelegate, CPListTemplateDelegate
{
    var interfaceController: CPInterfaceController?
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        
        // Store a reference to the interface controller so
        // you can add and remove templates as the user
        // interacts with your app.
        self.interfaceController = interfaceController
        
        /*
        let item1 = CPListItem(text: "El coche no arranca", detailText: "")
        let item2 = CPListItem(text: "Batería", detailText: "")
        let item3 = CPListItem(text: "Pinchazo", detailText: "")
        let item4 = CPListItem(text: "No tengo combustible", detailText: "")
          
        let listTemplate = CPListTemplate(title: "¿Cual es tu avería?", sections: [CPListSection(items:[item1, item2, item3, item4])])
        self.interfaceController?.setRootTemplate(listTemplate, animated: false)
        */
        
        
        
        
        
        
        /*
        if #available(iOS 14.0, *)
        {
            let item1 = CPInformationItem(title: "Hola que tal", detail: "Como estas")
            let item2 = CPInformationItem(title: "Yo me llamo", detail: "")
            
            let text1 = CPTextButton(title: "Avería", textStyle: .normal) { (CPTextButton) in
                
            }
            let text2 = CPTextButton(title: "Accidente", textStyle: .confirm) { (CPTextButton) in
                
            }
            
            let ttt = CPInformationTemplate(title: "report_ask_what".localized(), layout: .leading, items: [item1, item2], actions: [text1, text2])
            self.interfaceController?.setRootTemplate(ttt, animated: false)
            
        }
        else {
            // Fallback on earlier versions
        }
        */
        
        
        let temp = CPListTemplate(title: "", sections: [])
        self.interfaceController?.setRootTemplate(temp, animated: false)
        
        presentRootCar()
    }
    
    
    func listTemplate(_ listTemplate: CPListTemplate, didSelect item: CPListItem, completionHandler: @escaping () -> Void) {
        
        if let userInfo = item.userInfo as? [String: Any] {
            if let vehicle = userInfo["id1"] as? Vehicle, let isAccident = userInfo["id2"] as? Bool {
                if (isAccident)
                {
                    self.presentAccidentTemplate(vehicle: vehicle)
                }
                else
                {
                    self.presentFaultTemplate(vehicle: vehicle, parent: 2)
                }
            }
            else if let vehicle = userInfo["id2"] as? Vehicle, let incidenceType = userInfo["id1"] as? IncidenceType {
                
                if Core.shared.getIncidencesTypes(parent: incidenceType.id!) != nil {
                    self.presentFaultTemplate(vehicle: vehicle, parent: incidenceType.id!)
                }
                else
                {
                    self.presentInsuranceCallingTemplate(vehicle: vehicle, incidenceId: incidenceType.id!)
                }
            }
        }
    }
    
    func presentRootCar()
    {
        let action1 = CPAlertAction(title: "fault".localized(), style: .default) { (CPAlertAction) in
            
            let list = Core.shared.getVehicles()
            if (list.count > 0) {
                
                if (list.count == 1)
                {
                    let vehicle = list[0]
                    self.presentFaultTemplate(vehicle: vehicle, parent: 2)
                }
                else
                {
                    self.interfaceController?.dismissTemplate(animated: false)
                    self.presentVehicleListTemplate(isAccident: false)
                }
            }
            
            
            
            /*
            let grid1 = CPGridButton(titleVariants: ["El coche no arranca"], image: UIImage.init(named: "Car=Black")!) { (CPGridButton) in
                
            }
            let grid2 = CPGridButton(titleVariants: ["Batería"], image: UIImage.init(named: "Car=Blue")!) { (CPGridButton) in
                
            }
            
            let temp = CPGridTemplate(title: "¿Cual es tu avería?", gridButtons: [grid1, grid2])
            
            self.interfaceController?.dismissTemplate(animated: false)
            self.interfaceController?.setRootTemplate(temp, animated: true)*/
        }
        let action2 = CPAlertAction(title: "accident".localized(), style: .cancel) { (CPAlertAction) in
            
            let list = Core.shared.getVehicles()
            if (list.count > 0) {
                
                if (list.count == 1)
                {
                    let vehicle = list[0]
                    self.presentAccidentTemplate(vehicle: vehicle)
                }
                else
                {
                    self.interfaceController?.dismissTemplate(animated: false)
                    self.presentVehicleListTemplate(isAccident: true)
                }
            }
        }
        
        let template = CPAlertTemplate(titleVariants: ["report_ask_what".localized()], actions: [action1, action2])
        
        self.interfaceController?.presentTemplate(template, animated: false)
    }
    
    func presentAccidentTemplate(vehicle: Vehicle)
    {
        let action1 = CPAlertAction(title: "no".localized(), style: .default) { (CPAlertAction) in
            
            
            
        }
        let action2 = CPAlertAction(title: "yes".localized(), style: .cancel) { (CPAlertAction) in
            
            
        }
        
        let template = CPAlertTemplate(titleVariants: ["ask_wounded".localized()], actions: [action1, action2])
        
        self.interfaceController?.presentTemplate(template, animated: false)
    }
    
    func presentFaultTemplate(vehicle: Vehicle, parent: Int)
    {
        if let incidencesTypes = Core.shared.getIncidencesTypes(parent: parent) {
            
            var addeds = [CPListItem]()
            
            for inci in incidencesTypes {
                
                let item = CPListItem(text: inci.name, detailText: "")
                item.userInfo = ["id1": inci, "id2": vehicle]
                
                if #available(iOS 14.0, *) {
                    item.accessoryType = .disclosureIndicator
                }
                addeds.append(item)
            }
            
            let listTemplate = CPListTemplate(title: "ask_fault_simple".localized(), sections: [CPListSection(items: addeds)])
            if #available(iOS 14.0, *) {
                let backButton = CPBarButton.init(title: "") { (CPBarButton) in
                    self.interfaceController?.popTemplate(animated: false)
                }
                listTemplate.backButton = backButton
            }
            listTemplate.delegate = self
            
            self.interfaceController?.pushTemplate(listTemplate, animated: false)
        }
    }
    
    func presentVehicleListTemplate(isAccident: Bool)
    {
        var addeds = [CPListItem]()
        
        let list = Core.shared.getVehicles()
        if (list.count > 0) {
            for vehicle in list {
                
                let item = CPListItem(text: vehicle.getName(), detailText: "")
                item.userInfo = ["id1": vehicle, "id2": isAccident]
                
                if #available(iOS 14.0, *) {
                    item.accessoryType = .disclosureIndicator
                }
                addeds.append(item)
            }
        }
          
        let listTemplate = CPListTemplate(title: "ask_report_choose_vehicle_simple".localized(), sections: [CPListSection(items:addeds)])
        if #available(iOS 14.0, *) {
            let backButton = CPBarButton.init(title: "") { (CPBarButton) in
                //self.presentRootCar()
                self.interfaceController?.popTemplate(animated: false)
                self.presentRootCar()
            }
            listTemplate.backButton = backButton
        }
        listTemplate.delegate = self
        
        self.interfaceController?.pushTemplate(listTemplate, animated: false)
    }
    
    func presentInsuranceCallingTemplate(vehicle: Vehicle, incidenceId: Int)
    {
        
    }
}
