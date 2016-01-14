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
    @IBOutlet weak var questionBodyLabel: UILabel!

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
    
    //选择题选项按钮
    var answerAry = [UITextField]()
    func setAnswerTextFields(){
        let textFieldNumber = matchStringSymbol(question!.questionBody!)
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let offsetHeight = Int(answerPadView.frame.height)
        let offsetWidth = Int(screenWidth) - textFieldNumber*48
        frame.origin.y = CGFloat((offsetHeight-42)/2)
        frame.size.height = CGFloat(offsetHeight/2)
        for index in 0..<textFieldNumber{
            frame.origin.x = CGFloat((48 + offsetWidth/(textFieldNumber+1))*index + offsetWidth/(textFieldNumber+1))
            let textField = UITextField(frame: frame)
            textField.delegate = self
            textField.borderStyle = UITextBorderStyle.RoundedRect
            textField.backgroundColor = UIColor.blueColor()
            textField.addTarget(self, action: "didClickOptionTextField:", forControlEvents: UIControlEvents.EditingChanged)
            answerAry.append(textField)
            answerPadView.addSubview(textField)
        }
    }
    
    //MARK:选择选项按钮
    func didClickOptionTextField(textField:UITextField){
        _ = answerAry.indexOf(textField)
    }
    
    //MARK:回车键隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    //MARK:键盘弹出
    func keyboardWillShow(notification:NSNotification){if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect = CGRectMake(0.0, -200,width,height);
        self.view.frame = rect
        }
    }
    
    //MARK:键盘隐藏
    func keyboardWillHide(notification:NSNotification){
        self.view.addSubview(answerPadView)
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect = CGRectMake(0.0, 0,width,height);
        self.view.frame = rect
    }
    
    override func loadWithAnswer() {
        if let listAnswer = questionAnswer?.listAnswer {
            for (index,answer) in listAnswer.enumerate(){
                let result = answer as! NSDictionary
                answerAry[index].text = result["answer"] as? String
            }
        }
    }
    
    override func updateAnswer() {
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
