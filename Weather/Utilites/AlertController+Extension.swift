//
//  AlertController+Extension.swift
//  Weather
//
//  Created by kartheek.p on 20/01/21.
//  Copyright © 2021 Reshma.M. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    typealias OkCompletionHandler = (_ success: Bool) -> Void
    func showAlert(message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("", comment: ""),
                                                message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: UIAlertAction.Style.default) { (_ : UIAlertAction) -> Void in
            //printLog(value:"OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

  func showAlertWithTitle(message: String, with complition:@escaping OkCompletionHandler) {

        let alertController = UIAlertController(title: "", message: message,
                                                preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: UIAlertAction.Style.cancel) { (_ : UIAlertAction) -> Void in
            //printLog(value:"Cancel")
        }
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: UIAlertAction.Style.default) { (_ : UIAlertAction) -> Void in
            //printLog(value:"OK")
          complition(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertWithTitlewithCancelOption(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: UIAlertAction.Style.cancel) { (_ : UIAlertAction) -> Void in
            //printLog(value:"Cancel")
        }
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: UIAlertAction.Style.default) { (_ : UIAlertAction) -> Void in
            //printLog(value:"OK")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlertOkandCancelCompletionHandler(message: String, completionHandler:
        @escaping OkCompletionHandler) {
        let alertController = UIAlertController(title: "", message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: UIAlertAction.Style.default) {(_ : UIAlertAction) -> Void in
            let flag = false
            completionHandler(flag)
        }
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: UIAlertAction.Style.default) {(_ : UIAlertAction) -> Void in
            let flag = true
            completionHandler(flag)
        }
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertOkandCancelCompletionHandlerTM(title: String, message: String, completionHandler:
          @escaping OkCompletionHandler) {
          let alertController = UIAlertController(title: title, message: message,
                                                  preferredStyle: UIAlertController.Style.alert)
          let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""),
                                           style: UIAlertAction.Style.default) {(_ : UIAlertAction) -> Void in
              let flag = false
              completionHandler(flag)
          }
          alertController.addAction(cancelAction)

          let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""),
                                       style: UIAlertAction.Style.default) {(_ : UIAlertAction) -> Void in
              let flag = true
              completionHandler(flag)
          }
          alertController.addAction(okAction)

          self.present(alertController, animated: true, completion: nil)
      }
    func showAlertOkCompletionHandler(message: String, completionHandler: @escaping OkCompletionHandler) {
        let alertController = UIAlertController(title: "", message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: UIAlertAction.Style.default) {(_ : UIAlertAction) -> Void in
            let flag = true
            completionHandler(flag)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}
