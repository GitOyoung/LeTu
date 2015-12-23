//
//  DanxuanViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/15.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class DanxuanViewController: UIViewController {

    var question:EtaskQuestion?
    var etaskQuestionOptions = [EtaskQuestionOption]()
    
    // MARK: properties
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var answerPad: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    var answerButtonsAry = [UIButton]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(question)
        setQuestionBody(question)
        getEtaskQuestionOptions(question)
        setQuestionOptions()
        setAnswerButtons()
        scrollContentHeight.constant = 600
        scrollView.contentSize.height = 600
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setQuestionTitle(question:EtaskQuestion?) {

        questionTitleView.backgroundColor = QKColor.whiteColor()
        
        if let question = question {
            questionTitleView.ordinalLabel.text = String(question.ordinal)
            questionTitleView.titleLabel.text = question.type.displayTitle()
        } else {
            questionTitleView.ordinalLabel.text = "9"
            questionTitleView.titleLabel.text = "测试题型"
        }

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
        for (index,option) in etaskQuestionOptions.enumerate(){
            let ary = ["A","B","C","D"]
            let html_str = option.option!.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedString = try? NSAttributedString(data: html_str, options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
            str +=  ary[index] + (attributedString?.string)!
        }
        optionsLabel.text = str
    }
    
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let ary = ["A","B","C","D"]
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let offsetWidth = Int(screenWidth) - etaskQuestionOptions.count*44
        let offsetHeight = Int(answerPad.frame.height)
        print(offsetHeight)
        for (index,_) in etaskQuestionOptions.enumerate(){
            
            frame.origin.x = CGFloat((44 + offsetWidth/(etaskQuestionOptions.count+1))*index + offsetWidth/(etaskQuestionOptions.count+1))
            frame.origin.y = CGFloat((offsetHeight-44)/2)
            frame.size.height = CGFloat(offsetHeight/2)
            
            let button = UIButton(frame: frame)
            button.setTitle(ary[index], forState: .Normal)
            button.backgroundColor = UIColor.blueColor()
            answerPad.addSubview(button)
        }
    }
    //题目选项实例化
    func getEtaskQuestionOptions(question:EtaskQuestion?){
        if let question = question{
            if let options = question.options{
                for option in options{
                    etaskQuestionOptions.append(EtaskQuestionOption(option: option)!)
                }
            }
        }
    }
    
    
}
