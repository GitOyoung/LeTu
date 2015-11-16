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
    
    @IBOutlet weak var subSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.titleView.backgroundColor = QKColor.themeBackgroundColor_1()
        self.setMainSegment()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setMainSegment()
    {
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
}