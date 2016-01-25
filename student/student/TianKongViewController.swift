//
//  TianKongViewController.swift
//  student
//
//  Created by zhaoheqiang on 16/1/13.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

class TianKongViewController: QuestionBaseViewController,UITextFieldDelegate {

    @IBOutlet weak var quesstionTitleView: QuestionTitleView!
    @IBOutlet weak var questionBodyView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var answerPadView: UIView!
    @IBOutlet weak var answerPadWidth: NSLayoutConstraint!
    @IBOutlet weak var answerArea: UIView!
    @IBOutlet weak var answerAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var questionBodyLabel: UILabel!

    @IBOutlet weak var answerPadBottom: NSLayoutConstraint!
    //选择题选项按钮
    var answerAry = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(quesstionTitleView)
        setQuestionBody()
        setAnswerTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    

    func setQuestionBody(){
        if let question = question {
            let attributedStr = htmlFormatString(question.questionBody!)
            questionBodyLabel.text = attributedStr
        }
    }
    
    
    func setAnswerTextFields(){
        let count = matchStringSymbol(question!.questionBody!)
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        let w = CGFloat(count * 48 + (count - 1) * 10)
        answerPadWidth.constant = w
        frame.origin.y = (answerPadView.bounds.height - 42) / 2
        for i in 0..<count {
            let textField = UITextField(frame: frame)
            frame.origin.x += 58
            textField.tag = i
            textField.delegate = self
            textField.borderStyle = UITextBorderStyle.RoundedRect
            textField.layer.borderWidth = 2
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).CGColor
            textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            textField.addTarget(self, action: "didClickOptionTextField:", forControlEvents: UIControlEvents.TouchDown)
            answerAry.append(textField)
            answerPadView.addSubview(textField)
        }
        setAnswerLabel(count)
    }
    var answerLabelArray: [UILabel] = [UILabel]()
    
    func setAnswerLabel(count: Int) {
        var frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        for i in 0..<count {
            let label = UILabel(frame: frame)
            frame.origin.x += 40
            label.tag = i
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor(red: 0, green: 0.588, blue: 0.98, alpha: 1)
            label.font = UIFont.systemFontOfSize(18)
            label.textAlignment = .Left
            answerLabelArray.append(label)
            answerArea.addSubview(label)
        }
    }
    
    func updateLabelLayout() {
        var w: CGFloat = 0
        var needMult: Bool = false
        var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        for label in answerLabelArray {
            w += label.bounds.width
        }
        if w > answerArea.bounds.width {
            needMult = true
        }
        
        if needMult {
            for label in answerLabelArray {
                frame.size.width = label.bounds.width
                frame.size.height = label.bounds.height
                label.frame = frame
                frame.origin.y += 30
            }
            answerAreaHeight.constant = CGFloat(30 * answerLabelArray.count)
        } else {
            for label in answerLabelArray {
                frame.size.width = label.bounds.width
                frame.size.height = label.bounds.height
                label.frame = frame
                frame.origin.x += frame.width + 10
            }
            answerAreaHeight.constant = 30
        }
        
    }
    
    var textIndex: Int = -1
    
    //MARK:选择选项按钮
    func didClickOptionTextField(textField: UITextField) {
        textIndex = textField.tag
        textField.becomeFirstResponder()
    }
    
    //MARK:回车键隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textIndex = textField.tag
        let label = answerLabelArray[textIndex]
        label.text = textField.text
        label.sizeToFit()
        updateLabelLayout()
        textField.resignFirstResponder()
        
    }
    
    //MARK:键盘弹出
    func keyboardWillShow(notification:NSNotification) {
        if let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            answerPadBottom.constant = -keyboard.height + 50
        }
    }
    
    //MARK:键盘隐藏
    func keyboardWillHide(notification:NSNotification) {
        answerPadBottom.constant = 0
    }
    
    override func loadWithAnswer() {
        super.loadWithAnswer()
        if let listAnswer = questionAnswer?.listAnswer {
            for (index,answer) in listAnswer.enumerate(){
                let result = answer as! NSDictionary
                let string = result["answer"] as? String
                answerAry[index].text = string
                answerLabelArray[index].text = string
                answerLabelArray[index].sizeToFit()
            }
            updateLabelLayout()
        }
        
    }
    
    override func updateAnswer() {
        super.loadWithAnswer()
        var answerArray = [NSDictionary]()
        for (index,textField) in answerAry.enumerate(){
            let dic = getListAnswerItem(textField.text!, answerType: 0, ordinal: index)
            answerArray.append(dic)
        }
        questionAnswer?.listAnswer = answerArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
