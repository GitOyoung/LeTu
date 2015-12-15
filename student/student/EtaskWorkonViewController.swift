//
//  EtaskWorkonViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskWorkonViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initQuestions()
    }
    
    ///初始化题目
    func initQuestions() {
        
        let question1 = DanxuanViewController()
        self.addChildViewController(question1)
        self.contentView.addSubview(question1.view)
        //self.contentView.insertSubview(question1.view, belowSubview: self.contentView)
        
        let question2 = PanduanViewController()
        self.addChildViewController(question2)
        self.contentView.addSubview(question2.view)
        //self.contentView.insertSubview(question2.view, belowSubview: question1.view)
        
        let question3 = LianxianViewController()
        self.addChildViewController(question3)
        self.contentView.addSubview(question3.view)
        //self.contentView.insertSubview(question3.view, belowSubview: question2.view)
        
        let question4 = XuanzetiankongViewController()
        self.addChildViewController(question4)
        self.contentView.addSubview(question4.view)
        //self.contentView.insertSubview(question4.view, belowSubview: question3.view)
        
        self.contentView.bringSubviewToFront(self.contentView.subviews[0])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func preQuestion(sender: AnyObject) {
        //self.contentView.bringSubviewToFront(self.contentView.subviews.last!)
        self.contentView.exchangeSubviewAtIndex(0, withSubviewAtIndex: self.contentView.subviews.count-1)
        self.contentView.insertSubview(self.contentView.subviews.last!, atIndex: 1)
    }
    
    @IBAction func nextQuestion(sender: AnyObject) {
        //self.contentView.sendSubviewToBack(self.contentView.subviews.first!)
        self.contentView.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
        self.contentView.insertSubview(self.contentView.subviews[1], atIndex: self.contentView.subviews.count)
    }

    ///按钮 － 返回
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}