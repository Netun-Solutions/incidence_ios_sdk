//
//  PrimaryButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

public protocol KeyboardDismiss: AnyObject {

    func setUpHideKeyboardOnTap()
    func endEditingRecognizer() -> UIGestureRecognizer
}

public extension KeyboardDismiss where Self: UIViewController {

    func setUpHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
     
    func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
