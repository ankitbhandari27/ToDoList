//
//  ViewController.swift
//  TODOLIST
//
//  Created by Ankit Bhandari on 11/02/20.
//  Copyright © 2020 Ankit Bhandari. All rights reserved.
//

import UIKit

class TaskListVC: UIViewController {
    
    @IBOutlet weak var tblTask:UITableView!
    
    @IBOutlet var btnBarItem:UIBarButtonItem!
    @IBOutlet var btnTrash:UIBarButtonItem!
    
    var viewModel = TaskViewModel()
    @IBOutlet var segmentView:UISegmentedControl!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: UIControl.Event.valueChanged)
        
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setLayout()
    }
    
    // MARK:- Setup UI layout
    func setLayout() -> Void {
        
        tblTask.estimatedRowHeight = 100.0
        tblTask.rowHeight = UITableView.automaticDimension
        self.tblTask.addSubview(refreshControl)
        
        self.refreshControl.beginRefreshing()
        self.refreshControl.sendActions(for: .valueChanged)
        
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK:- Refrash Data And Call Api
    
    @objc func refreshData(_ refreshControl: UIRefreshControl) -> Void {
        
        self.getFeedData()
    }
    
    // MARK:- Call Api
    func getFeedData() -> Void {
        
        viewModel.getTaskListData {[weak self](success, message) in
            
            DispatchQueue.main.async {
                
                self?.refreshControl.endRefreshing()
                self?.tblTask.backgroundView = nil
                if success{
                    
                    self?.segmentAction(segment: self?.segmentView ?? UISegmentedControl())
                    
                }
                else{
                    self?.tableViewNoDataFound(message)
                }
            }
        }
    }
    
    @IBAction func segmentAction(segment:UISegmentedControl) -> Void {
        
        if segment.selectedSegmentIndex == 0 {
            
            self.navigationItem.rightBarButtonItem = nil
            
            self.viewModel.getCompleteTaksList()
            reloadData()
            
            if self.viewModel.getDeleteItem().count > 0{
                self.navigationItem.rightBarButtonItem = btnTrash
            }
        
        }
        else{
            
            self.viewModel.getPendingTaksList()
            
            self.navigationItem.rightBarButtonItem = btnBarItem
            
            if self.viewModel.getDeleteItem().count > 0{
                self.navigationItem.rightBarButtonItem = btnTrash
            }
        
            reloadData()
        }
    }
    
    func reloadData() -> Void {
        
        if (self.viewModel.arrTaskModel?.count ?? 0) > 0{
            self.tblTask.backgroundView  = nil
            self.tblTask.reloadData()
        }
        else{
            self.tableViewNoDataFound("No data found")
        }
    }
    
    
    //MARK: - Data Not found Method
    
    func tableViewNoDataFound(_ message:String) -> Void {
        
        self.viewModel.arrTaskModel?.removeAll()
        
        self.tblTask.backgroundView = CustomPopupView.alertMessageFromNib(fram: self.tblTask.frame, message: message,image: nil)
        
        self.tblTask.reloadData()
        
    }
    
    @IBAction func addButtonClicked(sender : AnyObject){
        let alertController = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add Task", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let numMax:Array<Int> = (self.viewModel.arrAllTaskModel?.map({$0.taskId}) ?? Array<Int>()) as! Array<Int>
            let taskModel = TaskListModel(taskId: (numMax.max() ?? 0) + 1, strTaskName: firstTextField.text, taskStatus: 0)
            self.viewModel.arrAllTaskModel?.insert(taskModel, at: 0)
            self.segmentAction(segment: self.segmentView)
        })
        saveAction.isEnabled = false
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "Enter Task Name"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    // If the text contains non whitespace characters, enable the OK Button
                    saveAction.isEnabled = textIsNotEmpty
                    
            })
        }
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
    
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAction() -> Void {
        
        self.showAlertView("Delete Item", "Are you sure you want to delete task?", defaultTitle: "Yes", cancelTitle: "No") {[weak self] (success) in
            if success{
                self?.viewModel.deleteItems()
                self?.segmentAction(segment: self?.segmentView ?? UISegmentedControl())
            }
        }
    }
}


// MARK:- UITableView delegates and datasource methods
extension TaskListVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.arrTaskModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tblTask.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else{
            return UITableViewCell()
        }
        
        
        let taskModel = self.viewModel.arrTaskModel?[indexPath.row]
        
        cell.lblTaskName.text = taskModel?.strTaskName ?? "-"
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        cell.viewBG.addGestureRecognizer(longPressRecognizer)
        
        cell.viewBG.tag = indexPath.row
        
        if self.viewModel.arrDeleteTask?.contains(taskModel?.taskId ?? -1) ?? false  {
            cell.viewBG.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
        else{
            cell.viewBG.backgroundColor = .white
        }
        cell.btnComplete.tag = indexPath.row
        cell.btnComplete.removeTarget(self, action: #selector(completeTask), for: .touchUpInside)
        cell.btnComplete.removeTarget(self, action: #selector(cancelCompleteTask), for: .touchUpInside)
        switch self.viewModel.taskType {
        case .completeTask:
            cell.btnComplete.isHidden = true
            break
        case .pendingTask:
            cell.btnComplete.isHidden = false
            
            if self.viewModel.arrTaskModel?[indexPath.row].taskStatus == 1{
                cell.btnComplete.setTitle("Cancel", for: .normal)
                cell.btnComplete.addTarget(self, action: #selector(cancelCompleteTask), for: .touchUpInside)
            }
            else{
                cell.btnComplete.setTitle("Complete", for: .normal)
                cell.btnComplete.addTarget(self, action: #selector(completeTask), for: .touchUpInside)
            }
            break
        }
        
        return cell
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        
        if sender.state == UIGestureRecognizer.State.ended {
            print("Long Press")
            
            guard let index = sender.view?.tag else {
                return
            }
            let taskModel = self.viewModel.arrTaskModel?[index]
            
            if self.viewModel.arrDeleteTask == nil {
                self.viewModel.arrDeleteTask = [Int]()
            }
            
            if self.viewModel.arrDeleteTask?.contains(taskModel?.taskId ?? -1) ?? false  {
                self.viewModel.arrDeleteTask?.removeObject(object: taskModel?.taskId ?? 0)
            }
            else{
                if let taskID = taskModel?.taskId{
                    self.viewModel.arrDeleteTask?.append(taskID)
                }
            }
            
            self.navigationItem.rightBarButtonItem = btnTrash
            btnTrash.tintColor = .white
            if self.viewModel.arrDeleteTask?.count ?? 0 == 0 {
                self.navigationItem.rightBarButtonItem = nil
            }
            
            self.tblTask.reloadData()
        }
        
    }
    
    @objc func completeTask(sender:UIButton) -> Void {
        self.viewModel.arrTaskModel?[sender.tag].taskStatus = 1
        self.tblTask.reloadData()
        let index = sender.tag
        
        delay(5.0) {
            self.finalCompleteTask(senderTag: index)
        }
    }
    
    @objc func finalCompleteTask(senderTag:Int) -> Void {
        
        if self.viewModel.arrTaskModel?.count ?? 0 > senderTag{
            
            let taskModel = self.viewModel.arrTaskModel?[senderTag]
            
            guard let index = self.viewModel.arrAllTaskModel?.firstIndex(where: {$0.taskId == taskModel?.taskId}) else{
                return
            }
            
            self.viewModel.arrAllTaskModel?[index].taskStatus = taskModel?.taskStatus
            
            self.segmentAction(segment: self.segmentView)
        }
    }
    
    @objc func cancelCompleteTask(sender:UIButton) -> Void {
        self.viewModel.arrTaskModel?[sender.tag].taskStatus = 0
        
        self.reloadData()
    }
}

// MARK:- UItableviewCell Class
class TaskCell: UITableViewCell {
    
    @IBOutlet weak var lblTaskName:UILabel!
    @IBOutlet weak var viewBG:UIView!
    @IBOutlet weak var btnComplete:UIButton!
    
    override func awakeFromNib() {
        
        viewBG.dropShadow()
        
    }
    
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
