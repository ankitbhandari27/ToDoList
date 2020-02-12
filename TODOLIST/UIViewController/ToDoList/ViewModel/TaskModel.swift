//
//  TaskModel.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 11/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import Foundation

struct TaskListModel:Decodable {
    
    var taskId: Int?
    var strTaskName: String?
    var taskStatus:Int?
    
    enum CodingKeys: String, CodingKey {
        case taskId = "id"
        case strTaskName = "task"
        case taskStatus = "state"
    }
    
}
