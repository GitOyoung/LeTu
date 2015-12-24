//
//  MainViewController.swift
//  student
//
//  Created by oyoung on 15/12/17.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class TabBarItem : UIControl
{
    var imageView: UIImageView?
    var textView: UILabel?
    var selectedColor: UIColor!
    override var selected: Bool {
        didSet {
            if selected {
                imageView?.image = selectedImage
                textView?.textColor = UIColor.whiteColor()
                backgroundColor = selectedColor
            }
            else {
                imageView?.image = image
                textView?.textColor = UIColor.grayColor()
                backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    var image: UIImage? //Normal
    var selectedImage: UIImage? //Selected
    init(frame: CGRect, images: [UIImage?], text: String) {
        super.init(frame: frame)
        image = images[0]
        selectedImage = images[1]
        imageView = UIImageView(image: image)
        var imgFrame = (imageView?.frame)!
        imgFrame.size = CGSizeMake(25, 25)
        imgFrame.origin = CGPoint(x: (frame.width - imgFrame.size.width) / 2, y: 6)
        imageView!.frame = imgFrame
        textView = UILabel(frame: CGRect( x: frame.width * 0.2, y: 36, width: frame.width * 0.6, height: frame.height * 0.2))
        textView?.font = UIFont.systemFontOfSize(10.0)
        textView?.textAlignment = .Center
        textView?.text = text
        textView?.textColor = UIColor.whiteColor()
        addSubview(imageView!)
        addSubview(textView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainViewController: UITabBarController
{
    
    var items: [TabBarItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
    }
    
    func setupTabBarItems()
    {
        var frame = tabBar.bounds
        
        let tabBarView: UIView = UIView(frame: tabBar.frame)
        tabBarView.backgroundColor = UIColor.whiteColor()
        let width = frame.width / 3
        frame.size.width = 60.0
        frame.origin.x = width  * 0.2
        
        let taskItem: TabBarItem = TabBarItem(frame: frame, images: [UIImage(named: "menu_task2"), UIImage(named: "menu_task1")], text: "作业")
        taskItem.tag = 0
        items.append(taskItem)
        
        frame.origin.x += width
        let hudong: TabBarItem = TabBarItem(frame: frame, images: [UIImage(named: "menu_hudong2"), UIImage(named: "menu_hudong1")], text: "互动")
        hudong.tag = 1
        items.append(hudong)
        
        frame.origin.x += width 
        let me: TabBarItem = TabBarItem(frame: frame, images: [UIImage(named: "menu_my2"), UIImage(named: "menu_my1")], text: "我的")
        me.tag = 2
        items.append(me)
        for item in items
        {
            item.selected = false
            item.selectedColor = UIColor(red: 0, green: 150.0/255, blue: 250.0/255, alpha: 1)
            tabBarView.addSubview(item)
            item.addTarget(self, action: Selector("tabBarTouched:"), forControlEvents: .TouchUpInside)
        }
        tabBar.hidden = true
        self.view.addSubview(tabBarView)
        items[0].selected = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarTouched(sender: TabBarItem)
    {
        didSelectTabBarIndex(sender.tag)
    }
    
    private var lastSelectedIndex: Int = 0
    func didSelectTabBarIndex(index: Int)
    {
        items[lastSelectedIndex].selected = false
        items[index].selected = true
        lastSelectedIndex = index
        selectedIndex = index
    }

    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch selectedIndex {
        case 0:
 
                //通知作业页面刷新
 
            break
        case 1:
            
            break
        case 2:
            
            break
        default:
            break
        }
    }
    //红色小圆点点加数字提醒新作业数量
    func showNumberTip(index idx: Int, number: Int) -> Void {
        let numberView = BubbleView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), backgroundColor: UIColor.redColor())
        
        numberView.text = "\(number)"
        
        var center = self.tabBar.center
        center.x = self.view.frame.size.width / 6 * CGFloat(idx + idx + 1)
        
        let tabBarHeight = self.tabBar.frame.height
        center.x += tabBarHeight / 4
        center.y -= tabBarHeight / 2
        
        numberView.center = center
        self.view.addSubview(numberView)
    }

}
