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
    @IBOutlet weak var padWidth: NSLayoutConstraint!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
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
    }
    
    //设置对错按钮
    func setAnswerButton() {
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        if let options = question?.options {
            let count = options.count
            let width = CGFloat(count * 48 + (count - 1) * 10)
//            let offsetHeight = answerPadView.frame.height
            padWidth.constant = width
//            frame.origin.y = (offsetHeight - 42) / 2
            for (index,_) in options.enumerate() {
                
                
                let button = UIButton(frame: frame)
                frame.origin.x += 58
                let buttonImage = index == 0 ? "rightAnswer" : "wrongAnswer"
                button.setImage(UIImage(named: buttonImage), forState: .Normal)
                button.backgroundColor = UIColor(red: 0, green: 150/255.0, blue: 250/255.0, alpha: 1)
                button.layer.cornerRadius = 6
                button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
                answerButtonsAry.append(button)
                answerPadView.addSubview(button)
            }
        }
    }
    
    //选择对错按钮事件
    func didClickOptionButton(button:UIButton){
        let answers = ["对", "错"]
        let index = answerButtonsAry.indexOf(button)!
        let option = question?.options![index]
        for button in answerButtonsAry {
            button.backgroundColor = UIColor(red: 0, green: 150/255.0, blue: 250/255.0, alpha: 1)
        }
        button.backgroundColor = UIColor(red: 116/255.0, green: 126/255.0, blue: 136/255.0, alpha: 1)
        print("选项：\(option!.option)")
        print("\(option!.optionIndex)")
        answerString = String(option!.optionIndex!)
        answerLabel.text = answers[index]
    }
    
    //判断scrollView是否允许滚动
    func setScrollEable(){
        let viewHeight = view.bounds.height
        let minHeight = viewHeight - questionTitleView.bounds.height - answerPadView.bounds.height
        let actualHeight = questionBodyLabel.bounds.height + 104
        if actualHeight > minHeight {
            scrollView.scrollEnabled = true
        }
        
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        questionAnswer?.answer = answerString
    }
    
    override func loadWithAnswer() {
        if(questionAnswer != nil && questionAnswer?.answer != ""){
            let options = question?.options!
            let str:String = questionAnswer!.answer
            let index:Int = Int(str)!
            for (i,option) in  (options?.enumerate())! {
                if(option.optionIndex! == index){
                    didClickOptionButton(answerButtonsAry[i])
                    break
                }
            }
        }
    }

}
