//
//  PrimaryButton.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

public protocol KeyboardListener: AnyObject {
    var scrollView: UIScrollView! { get }
    var contentInsetPreKeyboardDisplay: UIEdgeInsets? { get set }
    func keyboardChanged(with notification: Notification)
}

public extension KeyboardListener where Self: UIViewController {
    func keyboardChanged(with notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            guard let frameEnd = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                scrollView.contentInset.bottom = frameEnd.height
        } else {
            scrollView.contentInset.bottom = contentInsetPreKeyboardDisplay?.bottom ?? 0
        }
    }
    
    func setUpKeyboardObservers() {
        let center = NotificationCenter.default
        center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
           self?.keyboardChanged(with: notification)
        }
        center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
           self?.keyboardChanged(with: notification)
        }
    }
}
