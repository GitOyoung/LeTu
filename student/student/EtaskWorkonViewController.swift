//
//  EtaskWorkonViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskWorkonViewController: UIViewController, HttpProtocol, UIGestureRecognizerDelegate, QIndexViewControllerExitDelegate {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    // MARK: properties
    @IBOutlet weak var contentView: UIView!
    var etask:EtaskModel?
    var questions = [EtaskQuestion]()
    var answers = [Int: EtaskAnswer]()
    var currentQuestion:EtaskQuestion?
    
    var submitable: Bool = false {
        didSet {
            nextButton.setTitle(submitable ? "完成" : "下一题", forState: UIControlState.Normal)
        }
    }
    
    weak var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleView()
        loadQuestions()
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
    
    func setupTitleView() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("titleTouch:"))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        titleView.addGestureRecognizer(tap)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isKindOfClass(UIButton) {
            return false
        } else {
            return true
        }
    }
    
    func titleTouch(r: UITapGestureRecognizer) {
        showIndex(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //上一题
    @IBAction func preQuestion(sender: AnyObject) {
        saveAnswer()
        let index = (currentQuestion?.ordinal)! - 1
        submitable = false
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
                jumpToNextViewController()
            } else {
                submitable = true
            }
        }
        preButton?.enabled = true
    }

    ///按钮 － 返回
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func jumpToNextViewController() {
        let currentQuestionController = jumpToQuestionController(currentQuestion!)
        addViewControllerInContentView(currentQuestionController)
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
                    let currentQuestion = EtaskQuestion(data: currentQuestionData)
                    questions.append(currentQuestion)
                    hasDone.append(false)
                }
                currentQuestion = questions.first!
                jumpToNextViewController()
            }
        }
    }
    
    //判断应该跳往哪个题目页面
    func jumpToQuestionController(question:EtaskQuestion) -> UIViewController{
        let frame = contentView.bounds
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
//            questionController = FollowReadingViewController()
            questionController = YuYinGenDuViewController()
    
        case .TianKong:
            questionController = TianKongViewController()
        case .JianDa:
            questionController = JianDaViewController()
        case .DuoXuan:
            questionController = DanxuanViewController()
        }
        questionController!.question = currentQuestion
        if let ordinal = currentQuestion?.ordinal {
            questionController!.questionAnswer = answers[ordinal]
        } else {
            questionController!.questionAnswer = nil
        }
        
        print(questionController!.questionAnswer)
        questionController!.viewFrame = frame
        
        return questionController!
    }
    
    //题目添加到contentView内
    func addViewControllerInContentView(viewController:UIViewController){
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        for vc in childViewControllers {
            vc.removeFromParentViewController()
        }
        currentViewController = viewController
        titleLabel.text = "第\((currentQuestion?.ordinal)!)题"
        addChildViewController(viewController)
        contentView.addSubview(viewController.view)
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
        for (_, e) in answers {
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
        if let ordinal = currentQuestion?.ordinal {
            let index = ordinal - 1
            let vc = currentViewController as! QuestionBaseViewController
            answers[ordinal] = vc.answer()
            if  answers[ordinal]!.answer == "" {
                hasDone[index] = false
            } else {
                hasDone[index] = true
            }
        
        }
    }
    
    var hasDone: [Bool] = [Bool]()
    
    @IBAction func showIndex(sender: UIButton?) {
        if let _ = currentQuestion {
            let currentIndex = currentQuestion!.ordinal - 1
            var styles: [IndexStyle] = [IndexStyle]()
            for _ in 0..<questions.count {
                styles.append(.New)
            }
            for (i, done) in hasDone.enumerate() {
                styles[i] = done ? IndexStyle.Done : IndexStyle.New
            }
            
            let vc = QIndexViewController()
            vc.delegate = self
            vc.currentIndex = currentIndex
            vc.selectedIndex = currentIndex
            vc.collection = styles
            presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    func exit(viewController: QIndexViewController) {
        let nextIndex = viewController.selectedIndex
        let needChange: Bool = nextIndex != viewController.currentIndex
        if needChange {
            saveAnswer()
            submitable = false
            currentQuestion = questions[nextIndex]
            
            jumpToNextViewController()
        }
         viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}