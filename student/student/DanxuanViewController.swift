//
//  DanxuanViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/15.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class DanxuanViewController: QuestionBaseViewController {
    
    // MARK: properties
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var answerPad: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    var answerButtonsAry = [UIButton]()
    
    var answerString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        setQuestionOptions()
        setAnswerButtons()
        scrollContentHeight.constant = 600
        scrollView.contentSize.height = 600
        setScrollEable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question {
            let url = question.questionBody?.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedStr = try? NSAttributedString(data: url!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType , NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            questionBodyLabel.attributedText = attributedStr
        }
    }

    
    //TODO: 需要确认一下排序的问题
    func setQuestionOptions(){
        var str = ""
        let ary = ["A.","B.","C.","D."]
        for (index,option) in (question?.options!.enumerate())!{
            
            let html_str = option.option!
            let attributedString = htmlFormatString(html_str)
            str +=  ary[index] + attributedString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
            
        }
        optionsLabel.text = str
    }
    let ary = ["A","B","C","D"]
    //选择题选项按钮
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let options = question?.options!
        let count = options!.count
        let offsetHeight = answerPad.frame.height
        frame.origin.y = (offsetHeight - 42) / 2
        frame.origin.x = (screenWidth - CGFloat(count * 48 + (count - 1) * 10)) / 2
        for (index,_) in (question?.options!.enumerate())!{
           
            
            let button = UIButton(frame: frame)
            frame.origin.x += 58
            button.setTitle(ary[index], forState: .Normal)
            button.backgroundColor = UIColor(red: 0, green: 150/255.0, blue: 250/255.0, alpha: 1)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
            answerButtonsAry.append(button)
            answerPad.addSubview(button)
        }
    }
    
    //MARK:选择选项按钮
    func didClickOptionButton(button: UIButton){
        let index = answerButtonsAry.indexOf(button)
        let option = question?.options![index!]
        if question?.type == QuestionTypeEnum.DanXuan{
            for button in answerButtonsAry{
                button.backgroundColor = UIColor(red: 0, green: 150/255.0, blue: 250/255.0, alpha: 1)
            }
            answerString = String(option!.optionIndex!)+","
        }else{
            answerString += String(option!.optionIndex!)+","
        }
        answerLabel.text = ary[index!]
        button.backgroundColor = UIColor(red: 116/255.0, green: 126/255.0, blue: 136/255.0, alpha: 1)
    }
    //计算scrollView和屏幕的高度
    
    func setScrollEable(){
        let screenHeight = UIScreen.mainScreen().bounds.height
        let offsetHeight = screenHeight - 98 - questionTitleView.frame.size.width - answerPad.frame.size.height
        let contentHeight = questionBodyLabel.frame.size.height + optionsLabel.frame.size.height
        if offsetHeight > contentHeight{
            scrollView.scrollEnabled = false
        }
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        questionAnswer!.answer = answerString.clipLastString()
    }
    
    override func loadWithAnswer() {
        if questionAnswer != nil && questionAnswer?.answer != ""{
            let options = question?.options
            let strAry = questionAnswer!.answer.componentsSeparatedByString(",")
            print(strAry)
            for str in strAry{
                for (index,option) in (options?.enumerate())!{
                    if option.optionIndex! == Int(str){
                        let button = answerButtonsAry[index]
                        didClickOptionButton(button)
                        break
                    }
                }
            }
        }
    }
}











