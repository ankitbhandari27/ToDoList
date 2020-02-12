//
//  View.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 12/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import UIKit

extension UIView{
    
    func dropShadow(scale: Bool = true,radius: CGFloat = 10.0) {
        DispatchQueue.main.async {
            
            self.layer.cornerRadius = radius
    
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowOpacity = 0.15
            //self.layer.shadowPath = shadowPath.cgPath
        }
        
        self.layoutIfNeeded()
        
    }
    
}
