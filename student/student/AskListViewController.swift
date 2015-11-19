//
//  AskListViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class AskListViewController: UIViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var mainSegment: UISegmentedControl!
    
    @IBOutlet weak var subSegmentView: UIView!
    @IBOutlet weak var subSegment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.titleView.backgroundColor = QKColor.themeBackgroundColor_1()
        self.setMainSegment()
        self.setSubSegment()
        self.setSubSegmentView()
        self.setAllAskList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mainSegmentIndexChanged(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex
        {
        case 0:
            print("选中：全部")
        case 1:
            print("选中：语文")
        case 2:
            print("选中：数学")
        case 3:
            print("选中：英语")
        default:
            break
        }
    }
    
    private func setMainSegment() {
        // 设置segment
        // 去掉segment颜色,现在整个segment都看不见
        mainSegment.tintColor = QKColor.clearColor()
        // 设置选中／非选中时，文字属性
        mainSegment.setTitleTextAttributes([NSForegroundColorAttributeName: QKColor.themeBackgroundColor_1(), NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], forState: UIControlState.Selected)
        mainSegment.setTitleTextAttributes([NSForegroundColorAttributeName:QKColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(16)], forState: UIControlState.Normal)
        // 设置选中／非选中时，背景图片
        var selectedImage = UIImage.init(named: "ask_white_btn")
        selectedImage = selectedImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.Stretch)
        var unselectedImage = UIImage.init(named: "ask_blue_btn")
        unselectedImage = unselectedImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.Stretch)
        mainSegment.setBackgroundImage(unselectedImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        mainSegment.setBackgroundImage(selectedImage, forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        mainSegment.setBackgroundImage(selectedImage, forState: UIControlState.Highlighted, barMetrics: UIBarMetrics.Default)
    }
    
    private func setSubSegment() {
        subSegment.tintColor = QKColor.clearColor()
        subSegment.setTitleTextAttributes([NSForegroundColorAttributeName: QKColor.themeBackgroundColor_1(), NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: UIControlState.Selected)
        subSegment.setTitleTextAttributes([NSForegroundColorAttributeName:QKColor.themeFontColor_2(), NSFontAttributeName: UIFont.systemFontOfSize(14)], forState: UIControlState.Normal)
        var seperateImage = UIImage.init(named: "ask_seperate_line")
        seperateImage = seperateImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.Stretch)
        subSegment.setDividerImage(seperateImage, forLeftSegmentState: UIControlState.Selected, rightSegmentState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        subSegment.setDividerImage(seperateImage, forLeftSegmentState: UIControlState.Selected, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        subSegment.setDividerImage(seperateImage, forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
    }
    
    private func setSubSegmentView() {
        let bottomLine = CALayer.init()
        bottomLine.backgroundColor = QKColor.themeBackgroundColor_2().CGColor
        bottomLine.frame = CGRectMake(0, subSegmentView.frame.height, UIScreen.mainScreen().bounds.size.width, 1.5)
        subSegmentView.layer .addSublayer(bottomLine)
    }
    
    private func setAllAskList() {
        let allAsk = AskTableViewController()
        allAsk.tableView.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)
        tableView.addSubview(allAsk.tableView)
        self.addChildViewController(allAsk)
    }
}