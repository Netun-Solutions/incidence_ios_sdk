//
//  ErrorViewController.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 28/8/23.
//

import Foundation

class ErrorViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "ErrorScene"
    
    private var viewModel: ErrorViewModel! { get { return baseViewModel as? ErrorViewModel }}
    
    @IBOutlet weak var label: UILabel!
    
    static func create(with viewModel: ErrorViewModel) -> ErrorViewController {
        print("ErrorViewController create")
        let view = ErrorViewController.instantiateViewController(Bundle(for: Self.self))
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
        
        label.text = viewModel.error
        //setUpNavigation()
    }
}
