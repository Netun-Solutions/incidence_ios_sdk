//
//  ViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import UIKit
import IncidenceLibraryIOS

class DevelopmentViewController: UIViewController, StoryboardInstantiable, ReportTypeViewControllerDelegate {
    
    static var storyboardFileName = "DevelopmentScene"
    
    var dniIdentityType: IdentityType!
    var vehicleType: VehicleType!
    var color: ColorType!
    var policy: Policy!
    var user: User!
    var vehicle: Vehicle!
    var incidenceType: IncidenceType!
    var incidence: Incidence!
    
    static func create() -> DevelopmentViewController {
        print("DevelopmentViewController create")
        
        let view = DevelopmentViewController.instantiateViewController()
        //view.baseViewModel = DevelopmentViewModel()
        return view
    }
    
    override func viewDidLoad() {
        print("DevelopmentViewController viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dni = "25111111T"
        let phone = "650020001"
        let externalUserId = "25001"
        let externalVehicleId = "25001"
        let licensePlate = "2511XXX"
        let externalIncidenceId = "25001"
        
        dniIdentityType = IdentityType();
        dniIdentityType.name = "dni"; // (tipo de documento de identidad: dni, nie, cif)

        vehicleType = VehicleType();
        vehicleType.name = "Coche";

        color = ColorType();
        color.name = "Rojo";

        policy = Policy();
        policy.policyNumber = "222222222"; // (número de la póliza)
        policy.policyEnd = "2024-10-09"; // (fecha caducidad de la póliza)
        policy.identityType = dniIdentityType; // (tipo de documento identidad del asegurador)
        policy.dni = dni; // (documento de identidad del asegurador)

        user = User();
        user.externalUserId = externalUserId; // (identificador externo del usuario)
        user.name = "Nombre TEST"; // (nombre del usuario)
        user.phone = phone; // (teléfono)
        user.email = "sdkm2@tridenia.com"; // (e-mail)
        user.identityType = dniIdentityType;
        user.dni = dni; // (número del documento de identidad)
        user.birthday = "1979-09-29"; // (fecha de Nacimiento)
        user.checkTerms = 1; // (aceptación de la privacidad)

        vehicle = Vehicle();
        vehicle.externalVehicleId = externalVehicleId;
        vehicle.licensePlate = licensePlate; // (matrícula del vehículo)
        vehicle.registrationYear = 2022; // (fecha de matriculación)
        vehicle.vehicleType = vehicleType; // (tipo del vehículo)
        vehicle.brand = "Seat"; // (marca del vehículo)
        vehicle.model = "Laguna"; // (modelo del vehículo)
        vehicle.color = color; // (color del vehículo)
        vehicle.policy = policy;

        incidenceType = IncidenceType();
        //incidenceType.id = 5; // Pinchazo
        incidenceType.externalId = "B1"; // Pinchazo

        incidence = Incidence();
        incidence.incidenceType = incidenceType;
        incidence.street = "Carrer Major, 2";
        incidence.city = "Barcelona";
        incidence.country = "España";
        incidence.latitude = 41.4435945;
        incidence.longitude = 2.2319534;
        incidence.externalIncidenceId = externalIncidenceId;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGetDevicePressed(_ sender: Any) {
        IncidenceLibraryManager.shared.hasBeaconFunc(user: user, vehicle: vehicle, completion: { result in
            print(result)
            if (result.status) {
                self.showToast(controller: self, message: "SI hay baliza asociada")
            } else {
                self.showToast(controller: self, message: "NO hay baliza asociada")
            }
       })
    }
   
    @IBAction func btnDeviceCreatePressed(_ sender: Any) {
        let navigationController = IncidenceLibraryManager.shared.getDeviceCreateViewController(user: user, vehicle: vehicle, delegate: self)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnDeviceDeletePressed(_ sender: Any) {
        IncidenceLibraryManager.shared.deleteBeaconFunc(user: user, vehicle: vehicle, completion: { result in
            print(result)
            if (result.status) {
                self.showToast(controller: self, message: "Baliza desvinculada con éxito")
            } else {
                self.showToast(controller: self, message: "Baliza desvinculada con error: " + (result.message ?? ""))
            }
       })
    }
    
    @IBAction func btnDeviceReviewPressed(_ sender: Any) {
        let navigationController = IncidenceLibraryManager.shared.getDeviceReviewViewController(user: user, vehicle: vehicle, delegate: self)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnIncidenceCreatePressed(_ sender: Any) {
        IncidenceLibraryManager.shared.createIncidenceFunc(user: user, vehicle: vehicle, incidence: incidence, completion: { result in
            print(result)
            if (result.status) {
                self.showToast(controller: self, message: "Incidencia creada con éxito")
            } else {
                self.showToast(controller: self, message: "Incidencia creada con error: " + (result.message ?? ""))
            }
       })
    }
    
    @IBAction func btnIncidenceClosePressed(_ sender: Any) {
        IncidenceLibraryManager.shared.closeIncidenceFunc(user: user, vehicle: vehicle, incidence: incidence, completion: { result in
            print(result)
            if (result.status) {
                self.showToast(controller: self, message: "Incidencia cerrada con éxito")
            } else {
                self.showToast(controller: self, message: "Incidencia cerrada con error: " + (result.message ?? ""))
            }
       })
    }
    
    @IBAction func btnEcommercePressed(_ sender: Any) {
        let navigationController = IncidenceLibraryManager.shared.getEcommerceViewController(user: user, vehicle: vehicle)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnReportIncPressed(_ sender: Any) {
        let navigationController = IncidenceLibraryManager.shared.getReportIncViewController(user: user, vehicle: vehicle, delegate: self)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnReportIncSimpPressed(_ sender: Any) {
        let navigationController = IncidenceLibraryManager.shared.getReportIncSimpViewController(user: user, vehicle: vehicle, delegate: self)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnReportIncSimpOp1Pressed(_ sender: Any) {
        let navigationController = IncidenceLibraryManager.shared.getReportIncSimpOp1ViewController(user: user, vehicle: vehicle, delegate: self)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func btnGetGeoPressed(_ sender: Any) {
        IncidenceLibraryManager.shared.getGeo(user: user, vehicle: vehicle, completion: { result in
            print(result)
            if (result.status && result.data != nil) {
                
                let jsonData = try? JSONSerialization.data(withJSONObject: result.data!, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)!
                
                self.showToast(controller: self, message: "SI hay baliza asociada " + jsonString)
            } else {
                self.showToast(controller: self, message: "NO hay coordenadas")
            }
       })
    }
    
    func onResult(response: IncidenceLibraryIOS.IActionResponse) {
        print(response)
        if (response.status) {
            self.showToast(controller: self, message: "Incidencia creada con éxito")
        } else {
            self.showToast(controller: self, message: "Incidencia creada con error: " + (response.message ?? ""))
        }
    }
    
    func showToast(controller: UIViewController, message : String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.white
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 6

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
        alert.dismiss(animated: true)
        }
     }
}
