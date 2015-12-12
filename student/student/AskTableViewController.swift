//
//  AskTableViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/11/18.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class AskTableViewController: UITableViewController {
    var askBL = AskBL()
    var dataSource = NSMutableArray()
    var subjectName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // register table cell
        let bundle: NSBundle = NSBundle.mainBundle()
        let nib: UINib = UINib(nibName: "AskTableViewCell", bundle: bundle)
        tableView.registerNib(nib, forCellReuseIdentifier: "AskTableCell")
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        //tableView.separatorColor = UIColor.blackColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 144

        //添加刷新
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        refreshData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AskTableCell", forIndexPath: indexPath) as! AskTableViewCell
        
        var askCellModel:AskCellModel = dataSource[indexPath.section] as! AskCellModel
        
        cell.initCell(askCellModel)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight = 111
        var askCellModel:AskCellModel = dataSource[indexPath.section] as! AskCellModel
        switch askCellModel.pictures.count {
        case 1,2,3:
            rowHeight = 207
        case 4,5,6:
            rowHeight = 311
        case 7,8,9:
            rowHeight = 311
        default:
            rowHeight = 111
        }
        return CGFloat(rowHeight);
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Data refresh
    //滚动视图开始拖动
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if (!self.refreshControl!.refreshing) {
            self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        }
    }
    
    func refreshData() {
        self.refreshControl!.attributedTitle = NSAttributedString(string: "数据加载中......")
        switch subjectName {
        case "YUWEN":
            dataSource = askBL.findYuwen()
        case "SHUXUE":
            dataSource = askBL.findShuxue()
        case "YINGYU":
            dataSource = askBL.findYingyu()
        default:
            dataSource = askBL.findAll()
        }
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
}
