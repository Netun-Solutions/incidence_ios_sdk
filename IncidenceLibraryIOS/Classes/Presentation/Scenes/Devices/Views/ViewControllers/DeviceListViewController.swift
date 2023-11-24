//
//  DeviceListViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import UIKit

public class DeviceListViewController: IABaseViewController, StoryboardInstantiable {
    
    public static var storyboardFileName = "DevicesScene"
    private var viewModel: DeviceListViewModel! { get { return baseViewModel as? DeviceListViewModel }}
    
    private lazy var addBeacon: Beacon = {
        let beacon = Beacon()
        beacon.id = -1
        return beacon
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    public static func create(with viewModel: DeviceListViewModel) -> DeviceListViewController {
        
        //IncidenceLibraryManager.shared.validateScreen(screen: storyboardFileName)
        let bundle = Bundle(for: Self.self)
        
        let view = DeviceListViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        EventNotification.addObserver(self, code: .BEACON_DELETED, selector: #selector(beaconDeleted))
        EventNotification.addObserver(self, code: .BEACON_UPDATED, selector: #selector(beaconUpdated))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
        })?.removeFromSuperview()
    }
    
    @objc func beaconDeleted(_ notification: Notification) {
        if let beacon = notification.object as? Beacon {
            for (index, b1) in self.viewModel.devices.enumerated() {
                if (b1?.id == beacon.id) {
                    self.viewModel.devices.remove(at: index)
                    break
                }
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func beaconUpdated(_ notification: Notification) {
        if let beacon = notification.object as? Beacon {
            for (index, b1) in self.viewModel.devices.enumerated() {
                if (b1?.id == beacon.id) {
                    b1?.name = beacon.name
                    break
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func setUpUI() {
        super.setUpUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = ActiveSessionCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DevicesCell.self, forCellReuseIdentifier: DevicesCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
    }
    
    override func loadDataDelay() -> Bool {
        return true
    }
    override func loadData()
    {
        showHUD()
        Api.shared.getBeacons(completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                var beacons = result.getList(key: "beacons") ?? [Beacon]()
                //if (beacons.count == 0) {
                    beacons.append(self.addBeacon)
                //}
                self.viewModel.devices = beacons
                self.tableView.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
}


extension DeviceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.devices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DevicesCell.reuseIdentifier, for: indexPath) as? DevicesCell else {
            assertionFailure("Cannot dequeue reusable cell \(DevicesCell.self) with reuseIdentifier: \(DevicesCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.devices[indexPath.row]!)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let beacon = viewModel.devices[indexPath.row] {
            if (beacon.id == self.addBeacon.id)
            {
                let vm = RegistrationBeaconViewModel(origin: .addBeacon)
                vm.fromBeacon = true
                let viewController = RegistrationBeaconSelectTypeViewController.create(with: vm)
                navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                //let vm = DeviceDetailViewModel(device: beacon)
                //let vc = DeviceDetailViewController.create(with: vm)
                //navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DevicesCell.height
    }
}
