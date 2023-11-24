//
//  ViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import UIKit
import IncidenceLibraryIOS

class DevelopmentViewController: UIViewController, StoryboardInstantiable {
    
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
        incidenceType.externalId = "B10"; // Pinchazo

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
   
    @IBAction func btnDeviceCreatePressed(_ sender: Any) {
        let viewController = IncidenceLibraryManager.shared.getDeviceCreateViewController(user: user, vehicle: vehicle)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnDeviceDeletePressed(_ sender: Any) {
        //let viewController = IncidenceLibraryManager.shared.getDeviceListViewController()
        //navigationController?.pushViewController(viewController, animated: true)
        
        IncidenceLibraryManager.shared.deleteBeaconFunc(user: user, vehicle: vehicle, completion: { result in
            print(result)
       })
    }
    
    @IBAction func btnDeviceReviewPressed(_ sender: Any) {
        let viewController = IncidenceLibraryManager.shared.getDeviceListViewController(user: user, vehicle: vehicle)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnIncidenceCreatePressed(_ sender: Any) {
        //let viewController = IncidenceLibraryManager.shared.getIncidenceCreateViewController(user: user, vehicle: vehicle, incidence: incidence)
        //navigationController?.pushViewController(viewController, animated: true)
        
        IncidenceLibraryManager.shared.createIncidenceFunc(user: user, vehicle: vehicle, incidence: incidence, completion: { result in
            print(result)
       })
    }
    
    @IBAction func btnIncidenceClosePressed(_ sender: Any) {
        //let viewController = IncidenceLibraryManager.shared.getIncidenceCloseViewController(user: user, vehicle: vehicle, incidence: incidence)
        //navigationController?.pushViewController(viewController, animated: true)
        
        IncidenceLibraryManager.shared.closeIncidenceFunc(user: user, vehicle: vehicle, incidence: incidence, completion: { result in
            print(result)
       })
    }
    
    @IBAction func btnEcommercePressed(_ sender: Any) {
        let viewController = IncidenceLibraryManager.shared.getEcommerceViewController(user: user, vehicle: vehicle)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
