//
//  EtaskListViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//
import UIKit

class EtaskListViewController: UIViewController, HttpProtocol {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var mainSegment: UISegmentedControl!
    
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var tipsButton: UIButton!
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
 
    
    @IBOutlet weak var tableView: UIView!
    
    var http: HttpRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.titleView.backgroundColor = QKColor.themeBackgroundColor_1()
        http = HttpRequest()
        http?.delegate = self
        self.checkUser()
        self.setMainSegment()
        self.setSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentIndexChangedTips(sender: UISegmentedControl)
    {
        let selectSegText = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex);
        let message = String(format: "你选中了%@", selectSegText!);
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil);
        
        alert.addAction(cancelAction);
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    @IBAction func mainSegmentIndexChanged(sender: UISegmentedControl)
    {
        segmentIndexChangedTips(sender);
    }
    
    private func setSearchBar()
    {
        sortButton.layer.cornerRadius = 5
        searchBar.backgroundColor = UIColor.clearColor()
    }
    
    private func setMainSegment() {
        // 设置segment
        // 去掉segment颜色,现在整个segment都看不见
        mainSegment.tintColor = QKColor.clearColor()
        // 设置选中／非选中时，文字属性
        mainSegment.setTitleTextAttributes([NSForegroundColorAttributeName: QKColor.themeBackgroundColor_1(), NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], forState: UIControlState.Selected)
        mainSegment.setTitleTextAttributes([NSForegroundColorAttributeName:QKColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], forState: UIControlState.Normal)
        // 设置选中／非选中时，背景图片
        var selectedImage = UIImage(named: "ask_white_btn");
        selectedImage = selectedImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.Stretch);
        var unselectedImage = UIImage(named: "ask_blue_btn");
        unselectedImage = unselectedImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.Stretch);
        mainSegment.setBackgroundImage(unselectedImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default);
        mainSegment.setBackgroundImage(selectedImage, forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default);
        mainSegment.setBackgroundImage(selectedImage, forState: UIControlState.Highlighted, barMetrics: UIBarMetrics.Default);
        
        mainSegment.addTarget(self, action: Selector("mainSegmentIndexChanged:"), forControlEvents: UIControlEvents.ValueChanged);
    }
    private func setAllQuestionsList()
    {
        let allQs = EtaskTableViewController();
        allQs.tableView.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height);
        tableView.addSubview(allQs.tableView);
        self.addChildViewController(allQs);
    }
    
    
    private func checkUser()
    {
        if LTConfig.defaultConfig().defaultUser == nil
        {
            self.getUserInfo()
        }
        
    }
    
    func getUserInfo()
    {
        let url = ServiceApi.getLoginUrl()
        let params = NSDictionary(objects: ["xl5101","123456"], forKeys: ["userName", "pwd"])
        http?.postRequest(url, params: params)
    }
    
    
    func didreceiveResult(result: NSDictionary) {
        let isSuccess:Bool = result["isSuccess"] as! Bool
        if isSuccess
        {
            let status: String = result["status"] as! String
            let message:String = result["message"] as! String
            print(message)
            if status == "Y"
            {
                let student: Student = Student(info: result["user"] as? NSDictionary)
                LTConfig.defaultConfig().defaultUser = student
            }
            else
            {
                LTConfig.defaultConfig().defaultUser = nil
            }
            
            
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.setAllQuestionsList()
        }
    }
    
    @IBAction func jumpToNewEtaskView(sender: AnyObject) {
        let newEtaskVC = NewEtaskListViewController()
        self.presentViewController(newEtaskVC, animated: true, completion: nil)
    }

}