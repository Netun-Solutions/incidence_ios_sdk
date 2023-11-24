//
//  PrimaryButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

public protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype T
    static var storyboardFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> T
}

public extension StoryboardInstantiable where Self: UIViewController {
    static var storyboardFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = storyboardFileName
        
        let cBundle: Bundle? = bundle;
        /*
        if (bundle == nil) {
            cBundle = Bundle(for: Self.self)
        } else {
            cBundle = bundle!
        }
        */
        let storyboard = UIStoryboard(name: fileName, bundle: cBundle)
        
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
            
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return vc
    }
}
