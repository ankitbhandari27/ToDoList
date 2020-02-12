//
//  TaskViewModel.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 11/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import Foundation

enum TaskType {
    case completeTask
    case pendingTask
}

class TaskViewModel: NSObject {

    var arrAllTaskModel:[TaskListModel]?
    let taskListUrl = "karthikraj-duraisamy/todoendpoint/tasks"
    var arrTaskModel:[TaskListModel]?
    var arrDeleteTask:[Int]?
    var taskType:TaskType = .completeTask
    
    // MARK:- get feed data from api
    func getTaskListData(complitionHandler:@escaping (_ success:Bool,_ message:String)-> Void) {
        
        JSONParser.share.parseWithURL(taskListUrl, requestPrm: [:]) { [weak self] (responce) in
            
            if responce.isSuccess{
                
                if let data = responce.data {
                    // do stuffo
                    
                    do{
                        
                        let arrTaskList = try JSONDecoder().decode(Array<TaskListModel>.self, from: data)
                        self?.arrDeleteTask?.removeAll()
                        self?.arrAllTaskModel = arrTaskList
                        complitionHandler(true,responce.strMessage ?? "")
                    }
                    catch{
                        complitionHandler(false,responce.strMessage ?? "")
                    }
                }
                else{
                    complitionHandler(true,responce.strMessage ?? "")
                }
                
            }
            else{
                complitionHandler(false,responce.strMessage ?? "")
            }
        }
    }
    
    func getPendingTaksList() -> Void {
        self.taskType = .pendingTask
        self.arrTaskModel = self.arrAllTaskModel?.filter({$0.taskStatus == 0})
    }
    
    func getCompleteTaksList() -> Void {
        
        self.taskType = .completeTask
        self.arrTaskModel = self.arrAllTaskModel?.filter({$0.taskStatus == 1})
    }
    
    func getDeleteItem() -> [TaskListModel] {
        let arrDeleteItem = self.arrTaskModel?.filter({self.arrDeleteTask?.contains($0.taskId ?? 0) ?? false}) ?? [TaskListModel]()
        
        return arrDeleteItem
    }
    
    func deleteItems() -> Void {
        let arrDeleteTaskItem = self.getDeleteItem()
        
        for taskModel in arrDeleteTaskItem {
            guard let index = self.arrAllTaskModel?.firstIndex(where: {$0.taskId == taskModel.taskId}) else{
                return
            }
            self.arrDeleteTask?.removeObject(object: taskModel.taskId ?? -1)
            self.arrAllTaskModel?.remove(at: index)
        }
    }
}
