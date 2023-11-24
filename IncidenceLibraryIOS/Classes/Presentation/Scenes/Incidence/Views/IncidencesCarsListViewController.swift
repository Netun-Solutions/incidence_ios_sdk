//
//  IncidencesCarsListViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 12/5/21.
//


import UIKit

class IncidencesCarsListViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "IncidenceScene"
    private var viewModel: IncidencesCarsListViewModel! { get { return baseViewModel as? IncidencesCarsListViewModel }}
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    static func create(with viewModel: IncidencesCarsListViewModel) -> IncidencesCarsListViewController {
        let view = IncidencesCarsListViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
        })?.removeFromSuperview()
    }
    
    override func setUpUI() {
        super.setUpUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = VehicleColorCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(VehicleColorCell.self, forCellReuseIdentifier: VehicleColorCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
    }
    
    override func loadData()
    {
        showHUD()
        Api.shared.getVehicles(completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let vehicles = result.getList(key: "vehicles") ?? [Vehicle]()
                self.viewModel.vehicles = vehicles
                self.tableView.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
}


extension IncidencesCarsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleColorCell.reuseIdentifier, for: indexPath) as? VehicleColorCell else {
            assertionFailure("Cannot dequeue reusable cell \(VehicleColorCell.self) with reuseIdentifier: \(VehicleColorCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
     
        cell.configure(with: viewModel.vehicles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = IncidencesListViewModel(vehicle: viewModel.vehicles[indexPath.row]!)
        let vc = IncidencesListViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VehicleColorCell.height
    }
}

