//
//  RegistrationInsuranceViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//



import UIKit

class RegistrationInsuranceViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    var scrollView: UIScrollView! {
        get {
            return tableView
        }
    }

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newInsuranceLabel: TextLabel!
    @IBOutlet weak var newInsuranceButton: PrimaryButton!
    @IBOutlet weak var newInsuranceFieldView: TextFieldView!
    
    var filteredText: String = ""
    static var storyboardFileName = "RegistrationScene"
    let stepperView = StepperView()
    
    private var viewModel: RegistrationInsuranceViewModel! { get { return baseViewModel as? RegistrationInsuranceViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationInsuranceViewModel) -> RegistrationInsuranceViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationInsuranceViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }

    override func setUpUI() {
        super.setUpUI()
        
        setUpHideKeyboardOnTap()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = InsuranceCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: InsuranceCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: InsuranceCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        let padding = 16
        let size = 24
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = UIImage.app( "Search")
        outerView.addSubview(iconView)

        
        searchTextField.leftView = outerView
        searchTextField.leftViewMode = .always
        searchTextField.textColor = UIColor.app(.black)
        searchTextField.font = UIFont.app(.primaryRegular, size: 16)
        searchTextField.textColor = UIColor.app(.black)
        searchTextField.delegate = self
        searchTextField.font = UIFont.app(.primaryRegular, size: 16)
        searchTextField.attributedPlaceholder = NSAttributedString(string: viewModel.searchFieldText, attributes: [
            .foregroundColor: UIColor.app(.black500)!,
            .font: UIFont.app(.primaryRegular, size: 16)!
        ])
        
        newInsuranceLabel.text = viewModel.newInsuranceLabelText
        newInsuranceButton.setTitle(viewModel.newInsuranceButtonText, for: .normal)
        newInsuranceFieldView.title = viewModel.newInsuranceFieldTitleView
        
        /*
        //quitamos el poder crear de momento
        newInsuranceLabel.isHidden = true
        newInsuranceButton.isHidden = true
        newInsuranceFieldView.isHidden = true
        */
    }
    
    private func setUpStepperView() {
        switch viewModel.origin {
        case .editVehicle, .add:
            stepperView.totalStep = 2
        case .addBeacon:
            stepperView.totalStep = 1
        case .editInsurance:
            stepperView.totalStep = 0
        default:
            stepperView.totalStep = 3
        }
        
        if stepperView.totalStep > 0 {
            navigationController?.view.subviews.first(where: { (view) -> Bool in
                return view is StepperView
            })?.removeFromSuperview()

            navigationController?.view.addSubview(stepperView)
                
            if let view = navigationController?.navigationBar {
                stepperView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                stepperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
                stepperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
                stepperView.anchorCenterXToSuperview()
                stepperView.currentStep = 2
                stepperView.percentatge = 75
            }
        }
    }
    
    @IBAction func newInsuranceButtonPressed(_ sender: Any)
    {
        if let name = newInsuranceFieldView.value, name.count > 0 {
            
            var policyId = 1
            if self.viewModel.origin == .editInsurance {
                policyId = self.viewModel.vehicle?.policy?.id ?? 1
            } else {
                let vehicle = Core.shared.getVehicleCreating()
                policyId = vehicle.policy?.id ?? 1
            }
            
            showHUD()
            Api.shared.addInsurance(policyId: String(policyId), name: name, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    EventNotification.post(code: .INCIDENCE_REPORTED)
                    
                    let insurance:Insurance? = result.get(key: "insurance")
                    
                    self.viewModel.selectedInsurance = insurance
                    
                    if self.viewModel.origin == .editInsurance {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        
                        let vehicle = Core.shared.getVehicleCreating()
                        vehicle.insurance = insurance
                        
                        let vm = RegistrationInsuranceInfoViewModel(origin: self.viewModel.origin)
                        let viewController = RegistrationInsuranceInfoViewController.create(with: vm)
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                else
                {
                    self.onBadResponse(result: result)
                }
           })
            
        }
    }
    
    
    override func loadData()
    {
        showHUD()
        Api.shared.getInsurances(completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                var high = [Insurance]()
                var normal = [Insurance]()
                
                let insurances = result.getList(key: "insurances") ?? [Insurance]()
                for (_, insu) in insurances.enumerated()
                {
                    if (insu.relation == 1)
                    {
                        high.append(insu)
                    }
                    
                    normal.append(insu)
                }
                
                
                self.viewModel.allInsurances = normal
                self.viewModel.insurances = normal
                self.viewModel.highlightInsurances = high
                

                self.tableView.reloadData()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
        
    }
}

extension RegistrationInsuranceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if filteredText != "" { return 1 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredText != "" { return viewModel.filteredInsurances.count }
        
        if section == 0 {
            return viewModel.highlightInsurances.count
        }
        return viewModel.insurances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InsuranceCell.reuseIdentifier, for: indexPath) as? InsuranceCell else {
            assertionFailure("Cannot dequeue reusable cell \(InsuranceCell.self) with reuseIdentifier: \(InsuranceCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        if filteredText != "" {
            cell.configure(with: viewModel.filteredInsurances[indexPath.row], boldText: filteredText)
            
            return cell
        }
        cell.configure(with: indexPath.section == 0 ? viewModel.highlightInsurances[indexPath.row] : viewModel.insurances[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var insurance:Insurance
        
        if filteredText != "" {
            insurance = viewModel.filteredInsurances[indexPath.row]
        }
        else if indexPath.section == 0 {
            insurance = viewModel.highlightInsurances[indexPath.row]
        }
        else {
            insurance = viewModel.insurances[indexPath.row]
        }
        
        viewModel.selectedInsurance = insurance
        
        if viewModel.origin == .editInsurance {
            navigationController?.popViewController(animated: true)
        } else {
            
            let vehicle = Core.shared.getVehicleCreating()
            vehicle.insurance = insurance
            
            let vm = RegistrationInsuranceInfoViewModel(origin: viewModel.origin)
            let viewController = RegistrationInsuranceInfoViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = .clear
        let label = UILabel()
        label.font = UIFont.app(.primaryRegular, size: 10)
        label.textColor = UIColor.app(.black600)
        
        if filteredText != "" {
            label.text = "list_insurance".localized()
        }
        else {
            switch section {
            case 0:
                label.text = "featured_insurance".localized()
            default:
                label.text = "list_insurance".localized()
            }
        }
        
        
        sectionView.addSubview(label)
        label.anchorCenterYToSuperview()
        label.anchor(left: sectionView.leftAnchor, right: sectionView.rightAnchor, leftConstant: 24, rightConstant: 24)
        return sectionView
    }


    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
}

extension RegistrationInsuranceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            viewModel.filteredInsurances = viewModel.allInsurances.filter({ $0.name.uppercased().hasPrefix(updatedText.uppercased()) })
            filteredText = updatedText
        }
        tableView.reloadData()
        toggleNewInsurance()
        
        return true
    }
    
    private func toggleNewInsurance() {
        newInsuranceLabel.isHidden = !viewModel.filteredInsurances.isEmpty
        newInsuranceButton.isHidden = !viewModel.filteredInsurances.isEmpty
        newInsuranceFieldView.isHidden = !viewModel.filteredInsurances.isEmpty
        tableView.isHidden = viewModel.filteredInsurances.isEmpty
        
        newInsuranceFieldView.value = filteredText
        newInsuranceFieldView.showSuccess = true
    }
}
