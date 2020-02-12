//
//  CustomPopupView.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 11/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import UIKit

class CustomPopupView: UIView {
    
    // MARK:- Instance Object
    
    // Alert Message Parameter
    @IBOutlet var lblMessageAlert:UILabel!
    @IBOutlet var imgAlert:UIImageView!
    var isImageDisplay:Bool = false
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    // MARK:- Show error on tableview
    
    class func alertMessageFromNib( fram:CGRect,message:String,image:UIImage?) -> CustomPopupView {
        
        let view = UINib(nibName: "CustomPopupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPopupView
        view.frame = CGRect(x: 0, y: 0, width: fram.width, height: fram.height)
        //view.isHidden = false
        view.imgAlert.isHidden = true
        if image != nil {
            view.imgAlert.isHidden = false
            view.imgAlert.image = image
        }
        view.lblMessageAlert.text = message
        return view
        
    }
    
}
