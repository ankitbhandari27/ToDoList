//
//  File.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 12/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlertView(_ title:String,_ message:String, defaultTitle:String, cancelTitle:String, completionHandler: @escaping (_ value: Bool) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let btnOKAction = UIAlertAction(title: defaultTitle, style: .default) { (action) -> Void in
            completionHandler(true)
        }
        let btnCancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) -> Void in
            completionHandler(false)
        }
        alertController.addAction(btnOKAction)
        alertController.addAction(btnCancelAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.black
        
    }
}
