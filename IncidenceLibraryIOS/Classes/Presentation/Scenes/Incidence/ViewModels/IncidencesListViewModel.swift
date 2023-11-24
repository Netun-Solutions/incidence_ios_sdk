//
//  IncidencesListViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 12/5/21.
//

import Foundation

class IncidencesListViewModel: IABaseViewModel {
    /*
    var incidences: [Incidence?] = [Incidence(name: "Pinchazo en Lugo",
                                              date: "12 ene 2021",
                                              address: "c/ Gran vía",
                                              isActive: true,
                                              assesment: nil,
                                              progressItems: [
                                                ProgressItem(title: "Notificación de incidencia", subtitle: "12 ene 2021"),
                                                ProgressItem(title: "Aviso reportado a Reale", subtitle: nil),
                                                ProgressItem(title: "Grúa notificada", subtitle: nil)
                                              ]),
                                    Incidence(name: "Accidente en Lugo",
                                              date: "12 ene 2021",
                                              address: "c/ Gran vía",
                                              isActive: false,
                                              assesment: nil,
                                              progressItems: [
                                                  ProgressItem(title: "Notificación de incidencia", subtitle: "12 ene 2021"),
                                                  ProgressItem(title: "Aviso reportado a Reale", subtitle: "12 ene 2021"),
                                                  ProgressItem(title: "Grúa notificada", subtitle: "12 ene 2021"),
                                                  ProgressItem(title: "Grúa llega al destino", subtitle: "12 ene 2021")
                                              ]),
                                    Incidence(name: "Avería en Lugo",
                                              date: "12 ene 2021",
                                              address: "c/ Gran Vía ejemplo de text...",
                                              isActive: false,
                                              assesment: .regular,
                                              progressItems: [
                                                  ProgressItem(title: "Notificación de incidencia", subtitle: "12 ene 2021"),
                                                  ProgressItem(title: "Aviso reportado a Reale", subtitle: "12 ene 2021"),
                                                  ProgressItem(title: "Grúa notificada", subtitle: "12 ene 2021"),
                                                  ProgressItem(title: "Grúa llega al destino", subtitle: "12 ene 2021")
                                              ])
                                    ]*/
    
    var incidences: [Incidence?] = [Incidence]()
    
    
    var vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        self.incidences = vehicle.incidences ?? []
    }
    
    public override var navigationTitle: String? {
        get { return vehicle.getName() }
        set { }
    }
}
