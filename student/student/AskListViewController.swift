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
        self.titleView.backgroundColor = QKColor.themeBackgroundColor_1();
        self.setMainSegment()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setMainSegment()
    {
        // 设置segment
        // 去掉segment颜色,现在整个segment都看不见
//        mainSegment.tintColor = UIColor.clearColor()
//        // 设置选中／非选中时，文字属性
//        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//            NSForegroundColorAttributeName:[QKColor themeBackgroundColor]};
//        [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
//        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//            NSForegroundColorAttributeName: [UIColor whiteColor]};
//        [_segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
//        // 设置选中／非选中时，背景图片
//        UIImage *segmentSelected = [[UIImage imageNamed:@"white_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//        UIImage *segmentUnselected = [[UIImage imageNamed:@"blue_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//        [_segment setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [_segment setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//        [_segment setBackgroundImage:segmentSelected forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
}