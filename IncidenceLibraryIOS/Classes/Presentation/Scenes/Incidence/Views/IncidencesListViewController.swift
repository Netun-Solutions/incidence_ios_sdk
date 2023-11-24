//
//  IncidencesListViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 12/5/21.
//

import UIKit

class IncidencesListViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "IncidenceScene"
    private var viewModel: IncidencesListViewModel! { get { return baseViewModel as? IncidencesListViewModel }}
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    static func create(with viewModel: IncidencesListViewModel) -> IncidencesListViewController {
        let view = IncidencesListViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = IncidenceCell.height
        tableView.rowHeight = IncidenceCell.height
        tableView.register(IncidenceCell.self, forCellReuseIdentifier: IncidenceCell.reuseIdentifier)
        tableView.register(AddCell.self, forCellReuseIdentifier: AddCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
    }
    
}


extension IncidencesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.incidences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if viewModel.incidences.count == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCell.reuseIdentifier, for: indexPath) as? AddCell else {
                assertionFailure("Cannot dequeue reusable cell \(AddCell.self) with reuseIdentifier: \(AddCell.reuseIdentifier)")
                return UITableViewCell() }
            
            return cell
        }
        */
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IncidenceCell.reuseIdentifier, for: indexPath) as? IncidenceCell else {
            assertionFailure("Cannot dequeue reusable cell \(IncidenceCell.self) with reuseIdentifier: \(IncidenceCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
     
        cell.configure(with: viewModel.incidences[indexPath.row]!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = IncidencesDetailViewModel(vehicle: viewModel.vehicle, incidence: viewModel.incidences[indexPath.row]!)
        //let vc = IncidencesDetailViewController.create(with: vm)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IncidenceCell.height
    }
}

