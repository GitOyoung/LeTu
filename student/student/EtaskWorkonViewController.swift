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
    var questionControllers = [UIViewController]()
    var currentQuestionController = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadQuestions()
    }
    
    //加载题目
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
    
    //上一题
    @IBAction func preQuestion(sender: AnyObject) {
        let index = questionControllers.indexOf(currentQuestionController)
        if index! >= 1{
            let preQuestionController = questionControllers[index!-1]
            addViewControllerInContentView(preQuestionController)
        }
    }
    
    //下一题
    @IBAction func nextQuestion(sender: AnyObject) {
        let index = questionControllers.indexOf(currentQuestionController)
        if index!+1 < questionControllers.count{
            let nextQuestionController = questionControllers[index!+1]
            addViewControllerInContentView(nextQuestionController)
        }
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
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 98)
        for currentQuestionData in questionsData {
            let currentQuestion = EtaskQuestion.init(data: currentQuestionData)
            questions.append(currentQuestion)
            switch currentQuestion.type {
                case .DanXuan:
                    let danxuanController = DanxuanViewController()
                    danxuanController.question = currentQuestion
                    danxuanController.view.frame = frame
                    questionControllers.append(danxuanController)
                case .LianXian:
                    let lianxianViewController = LianxianViewController()
                    lianxianViewController.question = currentQuestion
                    lianxianViewController.view.frame = frame
                    questionControllers.append(lianxianViewController)
                case .PanDuan:
                    let panduanViewController = PanduanViewController()
                    panduanViewController.question = currentQuestion
                    panduanViewController.view.frame = frame
                    questionControllers.append(panduanViewController)
                case .PaiXu:
                    let paixuViewController = PaiXuCViewController()
                    paixuViewController.question = currentQuestion
                    paixuViewController.view.frame = frame
                    questionControllers.append(paixuViewController)
                case .XuanZeTianKong:
                    let viewController = XuanzetiankongViewController()
                    viewController.question = currentQuestion
                    viewController.view.frame = frame
                    questionControllers.append(viewController)
                case .TingLiTianKong:
                    let viewController = TingLiTiankongViewController()
                    viewController.question = currentQuestion
                    viewController.view.frame = frame
                    questionControllers.append(viewController)
                case .KouSuan:
                    let viewController = KouSuanViewController()
                    viewController.question = currentQuestion
                    viewController.view.frame = frame
                    questionControllers.append(viewController)
                default:
                        print("暂时的default")
                
            }
        }
        addViewControllerInContentView(questionControllers.first!)
    }
    
    //题目添加到contentView内
    func addViewControllerInContentView(viewController:UIViewController){
        currentQuestionController = viewController
        self.addChildViewController(viewController)
        self.contentView.addSubview(viewController.view)
    }
}