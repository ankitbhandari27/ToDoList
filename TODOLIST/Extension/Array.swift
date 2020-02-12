//
//  Array.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 12/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object: object)
        }
    }
    
}
