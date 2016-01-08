//
//  KouSuanViewController.swift
//  student
//
//  Created by luania on 15/12/29.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class KouSuanViewController: QuestionBaseViewController, passAnswerSetDataDelegate, passAnswerDataDelegate {
    
    @IBOutlet weak var startbutton: UIButton!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    
    var answerAry:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        initOptions()
        startbutton.layer.cornerRadius = 6
    }
    
    @IBAction func startButtonClicked(sender: UIButton) {
        let dialog = KouSuanAnswerSetViewController()
        dialog.delegate = self
        showDialog(dialog)
    }
    
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question {
            questionBodyLabel.text = htmlFormatString(question.questionBody!)
        }
    }
    
    func initOptions(){
        for subView in optionsView.subviews {
            subView.removeFromSuperview()
        }
        let options = question?.options
        for index in 0 ..< options!.count{
            let option = options![index]
            let index:Int = (options?.indexOf(option))!
            let line:UIView = UIView(frame: CGRect(x: 0, y: index*20, width: 200, height: 25))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            if(answerAry.count > index){
                let imageView = UIImageView(frame: CGRect(x: 180, y: 0, width: 20, height: 20))
                if(answerAry[index] == option.answer!){
                    var image = UIImage(named: "task_but_dui")
                    image = image!.imageWithRenderingMode(.AlwaysTemplate)
                    imageView.image = image
                    imageView.tintColor = QKColor.themeBackgroundColor_1()
                }else{
                    var image = UIImage(named: "task_but_cuo")
                    image = image!.imageWithRenderingMode(.AlwaysTemplate)
                    imageView.image = image
                    imageView.tintColor = UIColor.redColor()
                }
                line.addSubview(imageView)
            }
            line.addSubview(label)
            label.text = htmlFormatString(option.option!)
            optionsView.addSubview(line)
        }
    }
    
    func showDialog(dialog:UIViewController){
        dialog.view.backgroundColor = QKColor.makeColorWithHexString("000000", alpha: 0.5)
        presentViewController(dialog, animated: true, completion: nil)
    }
    
    //选择做题方式返回的时候执行
    func passAnswerSetData(answerWay: KouSuanAnswerWay, answerTimer: Int) {
        if(answerWay == KouSuanAnswerWay.keyboard){
            let dialog = KouSuanKeyboardViewController()
            dialog.options = self.question?.options
            dialog.delegate = self
            showDialog(dialog)
        }else {
            let dialog = KouSuanSpeakViewController()
            dialog.options = self.question?.options
            dialog.timer = answerTimer
            dialog.delegate = self
            showDialog(dialog)
        }
    }
    
    //做题完毕返回的时候执行
    func passAnswerData(answers: [String], costTime: Double) {
        answerAry = answers
        initOptions()
        let dialog = KouSuanResultViewController()
        showDialog(dialog)
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        print("updateAnswer")
        for str in answerAry {
            let dic = getListAnswerItem(str, answerType: 0, ordinal: answerAry.indexOf(str)!)
            print(dic)
            questionAnswer!.listAnswer.append(dic)
        }
        print(questionAnswer?.listAnswer)
    }
    
    override func loadWithAnswer() {
        print("hehe\(questionAnswer?.listAnswer == nil)")
        if(questionAnswer == nil || questionAnswer?.listAnswer == nil){
            return
        }
        for anAnswer in (questionAnswer?.listAnswer)!{
            var dic = anAnswer as! Dictionary<String,AnyObject>
            answerAry.append(dic["answer"] as! String)
        }
        initOptions()
    }
    
    func getListAnswerItem(str:String,answerType:Int,ordinal:Int) -> Dictionary<String,AnyObject>{
        var dic = Dictionary<String,AnyObject>()
        dic["answer"] = str
        dic["answerHistory"] = nil
        dic["answerType"] = answerType
        dic["isRight"] = 0
        dic["listAnswer"] = []
        dic["ordinal"] = ordinal
        dic["score"] = 0
        dic["type"] = 0
        return dic
    }
    
}

















