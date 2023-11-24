//
//  AccountActiveSessionsViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import UIKit

class AccountActiveSessionsViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "AccountScene"
    private var viewModel: AccountActiveSessionsViewModel! { get { return baseViewModel as? AccountActiveSessionsViewModel }}
    
    @IBOutlet weak var tableView: UITableView!
    
    var bottomSheetController: BottomSheetViewController?
    
    // MARK: - Lifecycle
    static func create(with viewModel: AccountActiveSessionsViewModel) -> AccountActiveSessionsViewController {
        let view = AccountActiveSessionsViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = ActiveSessionCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ActiveSessionCell.self, forCellReuseIdentifier: ActiveSessionCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
    }
    
    override func loadData()
    {
        showHUD()
        Api.shared.getSessions(completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                self.viewModel.activeSessions = result.getList(key: "sessions") ?? [Session]()
                self.tableView.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    private func configureBottomSheet(model: Session) {
        let view = ButtonsBottomSheetView()
  
        let title = String(format: "sign_out_on_device".localized(), model.getName())
        view.configure(delegate: self, title:nil, desc: title, firstButtonText: "cancel".localized(), secondButtonText: "sign_out".localized(), identifier: model)
        
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
}


extension AccountActiveSessionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activeSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActiveSessionCell.reuseIdentifier, for: indexPath) as? ActiveSessionCell else {
            assertionFailure("Cannot dequeue reusable cell \(ActiveSessionCell.self) with reuseIdentifier: \(ActiveSessionCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
     
        cell.configure(with: viewModel.activeSessions[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.activeSessions[indexPath.row]
        configureBottomSheet(model: model)
        present(bottomSheetController!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ActiveSessionCell.height
    }
}

extension AccountActiveSessionsViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: nil)
    }
    
    func secondButtonPressed(identifier: Any?) {
        guard let model = identifier as? Session else { return }
        
        showHUD()
        Api.shared.deleteSession(session: model, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                if let index = self.viewModel.activeSessions.firstIndex(where: { $0.id == model.id }) {
                    self.viewModel.activeSessions.remove(at: index)
                    self.tableView.reloadData()
                }
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
        
        bottomSheetController?.dismiss(animated: true, completion: nil)
    }
    
    
}
