//
//  EtaskWorkonViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskWorkonViewController: UIViewController, HttpProtocol {

    // MARK: properties
    @IBOutlet weak var contentView: UIView!
    var etask:EtaskModel?
    var questions = [EtaskQuestion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.initQuestions()
        self.loadQuestions()
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
    
    func loadQuestions() {
        if let etask = self.etask {
            // 获取电子作业详情地址
            let url: String = ServiceApi.getEtaskDetailUrl()
            // 判断是否已经有用户，如果有则发送请求
            if LTConfig.defaultConfig().defaultUser != nil{
                
                let student:Student = LTConfig.defaultConfig().defaultUser!
                
                let params:NSDictionary = ["etaskId":etask.etaskID!, "userId":student.uuid,"classesId":etask.classesId!,"recordId":etask.recordId!,"accessToken":student.accessToken!]
                let http:HttpRequest = HttpRequest()
                
                http.delegate = self
                
                http.postRequest(url, params: params)
            }
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func preQuestion(sender: AnyObject) {
        self.contentView.exchangeSubviewAtIndex(0, withSubviewAtIndex: self.contentView.subviews.count-1)
        self.contentView.insertSubview(self.contentView.subviews.last!, atIndex: 1)
    }
    
    @IBAction func nextQuestion(sender: AnyObject) {
        self.contentView.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
        self.contentView.insertSubview(self.contentView.subviews[1], atIndex: self.contentView.subviews.count)
    }

    ///按钮 － 返回
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //题目集合
    func didreceiveResult(result: NSDictionary) {
        let etask:NSDictionary = (result["data"] as? NSDictionary)!
        
        let questionsData = etask["etask"]!["etaskQuestions"] as! Array<NSDictionary>
        print("共有\(questionsData.count)个问题")
        for currentQuestionData in questionsData {
            let currentQuestion = EtaskQuestion.init(data: currentQuestionData)
            questions.append(currentQuestion)
            
            let frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.height)
            
            switch currentQuestion.type {
                case .DanXuan:
                    let danxuanController = DanxuanViewController()
                    danxuanController.question = currentQuestion
                    self.addChildViewController(danxuanController)
                    danxuanController.view.frame = frame
                    self.contentView.addSubview(danxuanController.view)
                 case .LianXian:
                    let lianxianViewController = LianxianViewController()
                    lianxianViewController.question = currentQuestion
                    self.addChildViewController(lianxianViewController)
                    lianxianViewController.view.frame = frame

                    lianxianViewController.view.hidden = true
                    
                    self.contentView.addSubview(lianxianViewController.view)
                case .PanDuan:
                    let panduanViewController = PanduanViewController()
                    panduanViewController.question = currentQuestion
                    self.addChildViewController(panduanViewController)
                    panduanViewController.view.frame = frame
                    panduanViewController.view.hidden = true
                    self.contentView.addSubview(panduanViewController.view)
                case .PaiXu:
                    let paixuViewController = PaiXuCViewController()
                    paixuViewController.question = currentQuestion
                    self.addChildViewController(paixuViewController)
                    paixuViewController.view.frame = frame
                    paixuViewController.view.hidden = true
                    self.contentView.addSubview(paixuViewController.view)
                default:
                        print("暂时的default")
                
            }
        }
        
        self.contentView.bringSubviewToFront(self.contentView.subviews[0])
        
    }
}