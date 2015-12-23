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
        setQuestionOptions(question)
        setAnswerButtons(question)
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
            let attributedStr = NSMutableAttributedString(string: question.questionBody!)
            questionBodyLabel.attributedText = attributedStr
        }
    }

    
    //TODO: 需要确认一下排序的问题
    func setQuestionOptions(question:EtaskQuestion?){
        if let question = question {
            if let options = question.options {
                var htmlStr = ""
                for option in options {
                    let optionStr = option["option"] as! String
                    htmlStr = htmlStr + optionStr
                }
                
                htmlStr = htmlStr + htmlStr
                htmlStr = htmlStr + htmlStr
                
                optionsLabel.text = htmlStr
            }
        }
    }
    
    func setAnswerButtons(question:EtaskQuestion?){
        if let question = question {
            if let options = question.options {
                var frame = CGRect(x: 16, y: 8, width: 44, height: 44)
                for (index, option) in options.enumerate() {
                    let button = UIButton()
                    
                    frame.origin.x = CGFloat(16 + 44 * (index + 8))
                    
                    button.frame = frame
                    button.setTitle(String(index), forState: .Normal)
                    answerPad.addSubview(button)
                }
            }
            
        }
    }
    
}
