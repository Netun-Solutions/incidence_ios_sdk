//
//  CarsBottomSheetView.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 28/5/21.
//

import UIKit

protocol CarsBottomSheetDelegate: AnyObject {
    func selectedIndex(_ index: Int)
}

final class CarsBottomSheetView: UIView {
  
    private weak var delegate: CarsBottomSheetDelegate?
    private var items: [Vehicle]?
    private var selectedItem: Int = 0
    
    // MARK: - UI Elements
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpUI()
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        setUpUI()
    }
    
    public func configure(delegate: CarsBottomSheetDelegate, vehicles: [Vehicle], selectedItem: Int) {
        self.delegate = delegate
        self.items = vehicles
        self.selectedItem = selectedItem
        
        tableView.reloadData()
    }
  
    private func setUpUI() {
        self.backgroundColor = UIColor.app(.white)
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VehicleSelectionCell.self, forCellReuseIdentifier: VehicleSelectionCell.reuseIdentifier)
    }

}

extension CarsBottomSheetView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleSelectionCell.reuseIdentifier, for: indexPath) as? VehicleSelectionCell else {
            assertionFailure("Cannot dequeue reusable cell \(VehicleSelectionCell.self) with reuseIdentifier: \(VehicleSelectionCell.reuseIdentifier)")
            return UITableViewCell()
        }
        guard let item = items?[indexPath.row] else { return UITableViewCell() }
        
        cell.configure(vehicle: item, isSelected: selectedItem == indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedIndex(indexPath.row)
    }
}
