//
//  EtaskTableViewController.swift
//  student
//
//  Created by oyoung on 15/11/26.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit


class EtaskTableViewController: UITableViewController, HttpProtocol {

    var dataSource = NSMutableArray()
    var subjectName:String = ""
    var newTaskCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tabel cell registerClass
        self.tableView!.registerClass(EtaskTableViewCell.self, forCellReuseIdentifier: "etaskTableViewCell")
        self.tableView.registerNib(UINib(nibName: "EtaskTableViewCell", bundle: nil), forCellReuseIdentifier: "etaskTableViewCell")
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(5, 10, 10, 10)
        
        //tableView.backgroundColor = QKColor.lightGrayColor()
        
        self.requestData(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("etaskTableViewCell", forIndexPath: indexPath) as! EtaskTableViewCell

        let etaskModel: EtaskModel = dataSource[indexPath.section] as! EtaskModel
        
        cell.initCell(etaskModel)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let etaskDetailVC = EtaskDetailViewController()
        //self.navigationController?.pushViewController(etaskDetailVC, animated: true)
        self.presentViewController(etaskDetailVC, animated: true, completion: nil)
    }
    
 

    // MARK: 刷新数据
    func requestData(pageIndex: Int) {
        let http: HttpRequest = HttpRequest()
        http.delegate = self
        let url = ServiceApi.getSearchEtaskListUrl()
        if LTConfig.defaultConfig().defaultUser != nil
        {
            let student:Student = LTConfig.defaultConfig().defaultUser!
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
            params["pageIndex"] = pageIndex
            params["pageSize"] = 10
            params["accessToken"] = student.accessToken
            http.postRequest(url, params: params)
        }
    }
    
    func didreceiveResult(result:NSDictionary) {
        print(result)
        if (result["isSuccess"] as! Bool) {
            newTaskCount = 0
            let resultData = result["data"] as! NSMutableArray
            for etask in resultData {
                let e = EtaskModel(info: etask["etask"] as? NSDictionary)
                dataSource.addObject(e)
                if e.isNewTask() {
                    newTaskCount++;
                }
            }
            if newTaskCount > 0 {
                NSNotificationCenter.defaultCenter().postNotificationName("NewTaskShowed", object: newTaskCount)
            }
            tableView.reloadData()
        }
    }
}
