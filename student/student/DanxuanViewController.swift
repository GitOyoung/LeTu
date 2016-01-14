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
    
    //选择题选项按钮
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        let ary = ["A","B","C","D"]
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let options = question?.options!
        let offsetWidth = Int(screenWidth) - (question?.options!.count)!*48
        let offsetHeight = Int(answerPad.frame.height)
        for (index,_) in (question?.options!.enumerate())!{
            
            frame.origin.x = CGFloat((48 + offsetWidth/(options!.count+1))*index + offsetWidth/(options!.count+1))
            frame.origin.y = CGFloat((offsetHeight-42)/2)
            frame.size.height = CGFloat(offsetHeight/2)
            
            let button = UIButton(frame: frame)
            button.setTitle(ary[index], forState: .Normal)
            button.backgroundColor = UIColor.blueColor()
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
        for button in answerButtonsAry{
            button.backgroundColor = UIColor.blueColor()
        }
        button.backgroundColor = UIColor.grayColor()
        answerString = String(option!.optionIndex)
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
        questionAnswer!.answer = answerString
    }
}











