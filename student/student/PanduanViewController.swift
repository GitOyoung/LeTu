//
//  PanduanViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/15.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class PanduanViewController: UIViewController {
    
    //MARK:properties
    var question:EtaskQuestion?
    var etaskQuestionOptions = [EtaskQuestionOption]()
    var answerButtonsAry = [UIButton]()
    
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var answerPadView: UIView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var questionOptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setQuestionTitle(question)
        setQuestionBody(question)
        getEtaskQuestionOptions(question)
        setQuestionOption()
        setAnswerButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: actions
    func setQuestionTitle(question:EtaskQuestion?){
        questionTitleView.backgroundColor = QKColor.whiteColor()
        
        if let question = question {
            questionTitleView.ordinalLabel.text = String(question.ordinal)
            questionTitleView.titleLabel.text = question.type.displayTitle()
        } else {
            questionTitleView.ordinalLabel.text = "9"
            questionTitleView.titleLabel.text = "测试题型"
        }

    }
    
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
        for option in etaskQuestionOptions{
            let html_str = option.option!.dataUsingEncoding(NSUTF8StringEncoding)
            let attributedString = try? NSAttributedString(data: html_str!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            str += (attributedString?.string)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
        }
        questionOptionLabel.text = str
    }
    
    //设置对错按钮
    func setAnswerButton(){
        var frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let offsetWidth = Int(screenWidth) - etaskQuestionOptions.count*44
        let offsetHeight = Int(answerPadView.frame.height)
        var buttonImage = ""
        for (index,_) in etaskQuestionOptions.enumerate(){
            
            frame.origin.x = CGFloat((44 + offsetWidth/(etaskQuestionOptions.count+1))*index + offsetWidth/(etaskQuestionOptions.count+1))
            frame.origin.y = CGFloat((offsetHeight-44)/2)
            frame.size.height = CGFloat(offsetHeight/2)
            
            let button = UIButton(frame: frame)
            buttonImage = index == 0 ? "rightAnswer" : "wrongAnswer"
            button.setImage(UIImage(named: buttonImage), forState: .Normal)
            button.backgroundColor = UIColor.grayColor()
            button.layer.borderWidth = 0.5
            button.layer.cornerRadius = 5
            button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
            answerButtonsAry.append(button)
            answerPadView.addSubview(button)
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
    
    //选择对错按钮事件
    func didClickOptionButton(button:UIButton){
        let index = answerButtonsAry.indexOf(button)!
        let option = etaskQuestionOptions[index]
        print("选项：\(option.option)")
        print("\(option.optionIndex)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
