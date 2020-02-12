//
//  String.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 11/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import Foundation

extension String {
    
    func isValidString() -> Bool
    {
        let strCheck = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let isValid = (strCheck.count > 0 ? true : false)
        
        return isValid;
    }
    
}
