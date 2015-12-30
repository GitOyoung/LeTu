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
    var currentQuestion:EtaskQuestion?

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
            if NSUserDefaultUtil.getUser() != nil{
                
                let user:UserModel = NSUserDefaultUtil.getUser()!
                
                let params:NSDictionary = ["etaskId":etask.etaskID!, "userId":user.userId!,"classesId":etask.classesId!,"recordId":etask.recordId!,"accessToken":user.token!]
                let http:HttpRequest = HttpRequest()
                
                http.delegate = self
                
                http.postRequest(url, params: params)
            }else{
                let meLoginViewController = MeLoginViewController()
                self.presentViewController(meLoginViewController, animated: true, completion: nil)
            }
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //上一题
    @IBAction func preQuestion(sender: AnyObject) {
        let index = questions.indexOf(currentQuestion!)
        if index! >= 1{
            let preQuestion = questions[index!-1]
            currentQuestion = preQuestion
            let preQuestionController = jumpToQuestionController(preQuestion)
            addViewControllerInContentView(preQuestionController)
        }
    }
    
    //下一题
    @IBAction func nextQuestion(sender: AnyObject) {
        let index = questions.indexOf(currentQuestion!)
        if index!+1 < questions.count{
            let nextQuestion = questions[index!+1]
            currentQuestion = nextQuestion
            let nextQuestionController = jumpToQuestionController(nextQuestion)
            addViewControllerInContentView(nextQuestionController)
        }
    }

    ///按钮 － 返回
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //题目集合
    func didreceiveResult(result: NSDictionary) {
        let code:String = result["code"] as! String
        if code == "20004"{
            let meLoginViewController = MeLoginViewController()
            self.presentViewController(meLoginViewController, animated: true, completion: nil)
        }else{
            let etask:NSDictionary = (result["data"] as? NSDictionary)!
            let questionsData = etask["etask"]!["etaskQuestions"] as! Array<NSDictionary>
            print("共有\(questionsData.count)个问题")
            for currentQuestionData in questionsData {
                let currentQuestion = EtaskQuestion.init(data: currentQuestionData)
                questions.append(currentQuestion)
            }
            currentQuestion = questions.first!
            let currentQuestionController = jumpToQuestionController(currentQuestion!)
            addViewControllerInContentView(currentQuestionController)
        }
    }
    
    //判断应该跳往哪个题目页面
    func jumpToQuestionController(question:EtaskQuestion) -> UIViewController{
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 98)
        var questionController:QuestionBaseViewController?
        
        switch question.type {
            case .DanXuan:
                questionController = DanxuanViewController()
            case .LianXian:
                questionController = LianxianViewController()
            case .PanDuan:
                questionController = PanduanViewController()
            case .PaiXu:
                questionController = PaiXuCViewController()
            case .XuanZeTianKong:
                questionController = XuanzetiankongViewController()
            case .TingLiTianKong:
                questionController = TingLiTiankongViewController()
            case .KouSuan:
                questionController = KouSuanViewController()
            case .TingLiXuanZe:
                questionController = TingLiTiankongViewController()
            default:
                return UIViewController()
        }
        questionController!.question = currentQuestion
        questionController!.view.frame = frame
        return questionController!
    }
    
    //题目添加到contentView内
    func addViewControllerInContentView(viewController:UIViewController){
        for view in self.contentView.subviews{
            view.removeFromSuperview()
        }
        self.addChildViewController(viewController)
        self.contentView.addSubview(viewController.view)
    }
}