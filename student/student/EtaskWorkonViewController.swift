//
//  EtaskWorkonViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskWorkonViewController: UIViewController, HttpProtocol {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var nextButton: UIButton!
    // MARK: properties
    @IBOutlet weak var contentView: UIView!
    var etask:EtaskModel?
    var questions = [EtaskQuestion]()
    var answers = [EtaskAnswer]()
    var currentQuestion:EtaskQuestion?
    
    var submitable: Bool = false
    
    weak var currentViewController: UIViewController?

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
            } else {
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
        saveAnswer()
        let index = (currentQuestion?.ordinal)! - 1
        submitable = false
        nextButton.setTitle("下一题", forState: UIControlState.Normal)
        if index > 0 {
            let preQuestion = questions[index - 1]
            currentQuestion = preQuestion
            let preQuestionController = jumpToQuestionController(preQuestion)
            addViewControllerInContentView(preQuestionController)
        } else {
            preButton = (sender as? UIButton)
            preButton?.enabled = false
        }
    }
    weak var preButton: UIButton?
    //下一题
    @IBAction func nextQuestion(sender: AnyObject) {
        saveAnswer()
        if submitable {
            alert("上传确认", message: "确认是否提交", ok: "确定", cancel: "取消", onOk: { action in
                self.submitAnswers()
            })
            
        } else {
            
            let index = (currentQuestion?.ordinal)!
            
            if index < questions.count {
                submitable = false
                let nextQuestion = questions[index]
                currentQuestion = nextQuestion
                let nextQuestionController = jumpToQuestionController(nextQuestion)
                addViewControllerInContentView(nextQuestionController)
            } else {
                submitable = true
                nextButton.setTitle("完成", forState: UIControlState.Normal)
            }
        }
        preButton?.enabled = true
    }

    ///按钮 － 返回
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //题目集合
    func didreceiveResult(result: NSDictionary) {
        let isSuccess = result["isSuccess"] as! Bool
        if isSuccess {
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
        case .LangDu:
            questionController = ReadingViewController()
        case .YuYinGenDu:
            questionController = FollowReadingViewController()
        case .TianKong:
            questionController = TianKongViewController()
        case .JianDa:
            questionController = JianDaViewController()
        case .DuoXuan:
            questionController = DanxuanViewController()
        }
        questionController!.question = currentQuestion
        let idx = (currentQuestion?.ordinal)! - 1
        questionController!.questionAnswer = idx < answers.count ? answers[idx] : nil
        questionController!.view.frame = frame
        return questionController!
    }
    
    //题目添加到contentView内
    func addViewControllerInContentView(viewController:UIViewController){
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        currentViewController = viewController
        titleLabel.text = "第\((currentQuestion?.ordinal)!)题"
        self.addChildViewController(viewController)
        self.contentView.addSubview(viewController.view)
    }
    //MARK: 提交作业
    func submitAnswers() {
        print("作业正在提交...请稍等")
        let params = NSMutableDictionary()
        let etaskAnswers = NSMutableArray()
        let u = NSUserDefaultUtil.getUser()
        let formater = NSDateFormatter()
        formater.locale = NSLocale.autoupdatingCurrentLocale()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for e in answers {
            etaskAnswers.addObject(e.toDictionary())
        }
        params["etaskId"] = etask?.etaskID
        params["userId"] = u?.userId
        params["classesId"] = etask?.classesId
        params["recordId"] = etask?.recordId
        params["answerTime"] = formater.stringFromDate(NSDate())
        params["accessToken"] = u?.token
        params["etaskAnswerType"] = 1
        params["etaskAnswers"] = etaskAnswers
        params["behaviorAnalysis"] = NSArray()
        
        let url = ServiceApi.getEtasksubmitUrl()
        
        let http = HttpRequest()
        http.delegate = self
        http.postRequest(url, params: params)
    }
    func submitDidSucceed() {
        print("作业提交成功！")
        goBack(self)
    }
    
    //MARK: 保存答案到答案列表
    func saveAnswer() {
        if var idx = currentQuestion?.ordinal {
            --idx
            let vc = currentViewController as! QuestionBaseViewController
            if idx < answers.count {
                answers[idx] = vc.answer()
            } else {
                answers.append(vc.answer())
            }
        }
    }
}