//
//  EtaskTableViewController.swift
//  student
//
//  Created by oyoung on 15/11/26.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit


class EtaskTableViewController: UITableViewController, HttpProtocol {

    var http: HttpRequest?
    var dataSource: NSMutableArray?
    var etaskData:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        http = HttpRequest()
        http!.delegate = self
        
        //tabel cell registerClass
        self.tableView!.registerClass(EtaskTableViewCell.self, forCellReuseIdentifier: "etaskTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EtaskTableViewCell", bundle: nil), forCellReuseIdentifier: "etaskTableViewCell")
        self.updateDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return etaskData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("etaskTableViewCell", forIndexPath: indexPath) as! EtaskTableViewCell
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let rowData:NSDictionary = etaskData[indexPath.row] as! NSDictionary
        cell.titleLabel.text = "我是小强"
        cell.detailLabel.text = "你好你好"
        return cell
    }
    
    
    
    func updateDataSource() {
        let url = ServiceApi.getSearchEtaskListUrl()
        if LTConfig.defaultConfig().defaultUser != nil
        {
            
            let student:Student = LTConfig.defaultConfig().defaultUser!

            //            let params = NSDictionary(objects: [student.uuid as AnyObject,student.accessToken as! AnyObject], forKeys: ["userID", "accessToken"])
/*
            userId	Long	是		用户ID
            orderDate	Integer	是	1	是否按作业开始日期排序类型 (1:是 0:否)
            status	Integer	是	0	状态,按照作业状态进行筛选
            0:全部 1:未开始 2:未完成 3:未批改 4:未订正 5:已完成
            subject	Integer	是	0	科目,按照科目进行筛选
            0:全部 1:语文 2:数学 3:英语 (暂时只是小学阶段语数外)
            timeSlice	Integer	是	0	按照时间段来筛选
            0:全部 1:当天 2:本周 3:当月 4:本学期
            etaskType	Integer	是	0	作业类型 0:全部 1:随堂练习 2:假期作业
            pageIndex	Integer	是	0	获取数据的页面索引,默认为0
            pageSize	Integer	是	10	每次获取数据的数量,默认为10
            accessToken
*/
            var params = [String:AnyObject]()
            params["userId"] = student.uuid
            params["orderDate"] = 1
            params["status"] = 0
            params["subject"] = 0
            params["timeSlice"] = 0
            params["etaskType"] = 0
            params["pageIndex"] = 0
            params["pageSize"] = 10
            params["accessToken"] = student.accessToken
            http?.postRequest(url, params: params)
        }
    }

    func didreceiveResult(result: NSDictionary) {
        etaskData = result["data"] as! NSArray
        self.tableView.reloadData()
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

}
