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
        let options = question?.options
        for option in options!{
            let index:Int = (options?.indexOf(option))!
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: index*20, width: 100, height: 20))
            label.text = htmlFormatString(option.option!)
            optionsView.addSubview(label)
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
        
        let dialog = KouSuanResultViewController()
        showDialog(dialog)
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        for (index,str) in answerAry.enumerate() {
            let dic = getListAnswerItem(str, answerType: 0, ordinal: index)
            questionAnswer!.listAnswer?.append(dic)
        }
    }
    
}

















