//
//  ReportIncidenceSimpleViewController.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 7/11/23.
//

import Foundation

class ReportIncidenceSimpleViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "ReportIncidenceSimpleScene"
    
    private var viewModel: ReportIncidenceSimpleViewModel! { get { return baseViewModel as? ReportIncidenceSimpleViewModel }}
    
    @IBOutlet weak var label: UILabel!
    
    static func create(with viewModel: ReportIncidenceSimpleViewModel) -> ReportIncidenceSimpleViewController {
        print("ReportIncidenceSimpleViewController create")
        let view = ReportIncidenceSimpleViewController.instantiateViewController(Bundle(for: Self.self))
        view.baseViewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        print("DevelopmentViewController viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        //label.text = viewModel.error
        //setUpNavigation()
    }
}
