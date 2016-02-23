//
//  ViewController.swift
//  SwiftSource
//
//  Created by Nguyen Anh Minh on 2/22/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskCellDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIndentifier = "TaskCell";
    private let data: DataUtils = DataUtils.getInstance
    private var dataList: [Task] = [Task]()
    
    private var searchResultController: SearchResultController! = nil
    private var searchController: UISearchController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataList = self.data.fetchEntity("Task", condition: nil, sortCondition: nil, limit: -1, bind: "Task") as! [Task]
        self.dataList.append(Task())
        self.tableView.registerNib(UINib(nibName: cellIndentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIndentifier)
        
        self.searchResultController = SearchResultController()
        
        self.searchController = UISearchController(searchResultsController: self.searchResultController)
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UISearchController update
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        let condition = NSPredicate(format: "name CONTAINS[cd] %@", searchText!)
        
        let controller = searchController.searchResultsController as! SearchResultController!
        controller.filtedData = self.data.fetchEntity("Task", condition: condition, sortCondition: nil, limit: -1, bind: "Task") as! [Task]
    }
    
    // MARK: UITabelView's Delegate and DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TaskCell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as! TaskCell
        
        let task = self.dataList[indexPath.row]
        
        cell.delegate = self
        cell.setContentData(task)
        
        return cell
    }
    
    // MARK: UITableViewCell delegate
    func taskCell(cell: TaskCell, didTapButton sender: UIButton) {
        
        let action = TaskCell.ActionStyle(rawValue: sender.tag)
        
        switch(action!){
        case TaskCell.ActionStyle.Add:
            let task = self.dataList.last as Task!
            task.name = cell.inputTextField.text
            task.createDate = NSDate()
            task.id = NSProcessInfo.processInfo().globallyUniqueString
            if (self.data.updateEntity("Task", condition: nil, values: task.dictionary) == false){
                return
            }
            self.dataList.append(Task())
            self.tableView.reloadData()
            break
        case TaskCell.ActionStyle.Delete:
            let indexPath = self.tableView.indexPathForCell(cell)
            if (indexPath == nil){
                return
            }
            let task = self.dataList[indexPath!.row]
            let condition = NSPredicate(format: "id == %@", task.id!)
            if (self.data.deleteEntity("Task", condition: condition) == false){
                return
            }
            self.dataList.removeAtIndex(indexPath!.row)
            self.tableView.reloadData()
            break
        }
        
    }
    
    func taskCell(cell: TaskCell, didEndEditing sender: UITextField) {
        let indexPath = self.tableView.indexPathForCell(cell)
        if (indexPath == nil){
            return
        }
        let task = self.dataList[indexPath!.row]
        task.name = sender.text
        
        let condition = NSPredicate(format: "id == %@", task.id!)
        
        if (self.data.updateEntity("Task", condition: condition, values:["name":task.name!]) == false){
            return
        }
    }
}

