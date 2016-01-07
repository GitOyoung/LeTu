//
//  PanduanViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/15.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class PanduanViewController: QuestionBaseViewController {
    
    //MARK:properties
    var answerButtonsAry = [UIButton]()
    
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var answerPadView: UIView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var questionOptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var answerString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        setQuestionOption()
        setAnswerButton()
        setScrollEable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: actions
    
    //设置题目主干
    func setQuestionBody(question: EtaskQuestion?){
        if let question = question{
            let html_str = question.questionBody!.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedString = try? NSAttributedString(data: html_str, options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
            questionBodyLabel.text = attributedString?.string
        }
    }
    
    //设置题目选项
    func setQuestionOption(){
        var str = ""
        for option in (question?.options!)!{
            let html_str = option.option!.dataUsingEncoding(NSUTF8StringEncoding)
            let attributedString = try? NSAttributedString(data: html_str!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            str += (attributedString?.string)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
        }
        questionOptionLabel.text = str
    }
    
    //设置对错按钮
    func setAnswerButton() {
        let options = question?.options
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let offsetWidth = Int(screenWidth) - options!.count*48
        let offsetHeight = Int(answerPadView.frame.height)
        var buttonImage = ""
        for (index,_) in options!.enumerate() {
            
            frame.origin.x = CGFloat((48 + offsetWidth/(options!.count+1))*index + offsetWidth/(options!.count+1))
            frame.origin.y = CGFloat((offsetHeight-42)/2)
            frame.size.height = CGFloat(offsetHeight/2)
            
            let button = UIButton(frame: frame)
            buttonImage = index == 0 ? "rightAnswer" : "wrongAnswer"
            button.setImage(UIImage(named: buttonImage), forState: .Normal)
            button.backgroundColor = UIColor.blueColor()
            button.layer.borderWidth = 0.5
            button.layer.cornerRadius = 6
            button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
            answerButtonsAry.append(button)
            answerPadView.addSubview(button)
        }
    }
    
    //选择对错按钮事件
    func didClickOptionButton(button:UIButton){
        let index = answerButtonsAry.indexOf(button)!
        let option = question?.options![index]
        for button in answerButtonsAry{
            button.backgroundColor = UIColor.blueColor()
        }
        button.backgroundColor = UIColor.grayColor()
        print("选项：\(option!.option)")
        print("\(option!.optionIndex)")
        answerString = String(option!.optionIndex)
    }
    
    //判断scrollView是否允许滚动
    func setScrollEable(){
        let screenHeight = UIScreen.mainScreen().bounds.height
        let offsetHeight = screenHeight - 98 - questionTitleView.frame.size.width - answerPadView.frame.size.height
        let contentHeight = questionBodyLabel.frame.size.height + questionOptionLabel.frame.size.height
        if offsetHeight > contentHeight{
            scrollView.scrollEnabled = false
        }
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        questionAnswer?.answer = answerString
    }
}
