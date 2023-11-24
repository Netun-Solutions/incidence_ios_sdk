#if canImport(UIKit)
import UIKit

/// A transitioning delegate object providing custom transiton and presentation behaviour for `BottomSheetViewController`.
public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    /*
  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    guard let presentedController = presented as? BottomSheetViewController else { return nil }
    return BottomSheetPresentationController(
      presentedViewController: presentedController,
      presenting: presenting
    )
  }
   */
    
    
    public func presentationController(
            forPresented presented: UIViewController,
            presenting: UIViewController?,
            source: UIViewController
        ) -> UIPresentationController? {
            
            
            /*
            if #available(iOS 15.0, *)
            {
                let controller = UISheetPresentationController(presentedViewController: presented, presenting: presenting)
                controller.prefersScrollingExpandsWhenScrolledToEdge = true
                controller.detents = [.medium(), .large()]
                controller.prefersGrabberVisible = false
                return controller
            }
            else
            {*/
                // Fallback on earlier versions
                guard let presentedController = presented as? BottomSheetViewController else { return nil }
                return BottomSheetPresentationController(
                  presentedViewController: presentedController,
                  presenting: presenting
                )
            //}
            
            
        }
    
    
}

#endif
