//
//  LianxianViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/15.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class LianxianViewController: QuestionBaseViewController {
    
    @IBOutlet weak var questionTitleView:QuestionTitleView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var lianXianView: LianXianView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTitleView.setData(question)
        setQuestionBody(question)
        lianXianView.setQuestion(question)
    }
    
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question {
            let questionBody = question.questionBody?.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedStr = try? NSAttributedString(data: questionBody!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType , NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            questionBodyLabel.attributedText = attributedStr
        }
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        var answerString:String = ""
        for (key,value) in lianXianView.connections {
            answerString = answerString+"\(key)-\(value),"
        }
        questionAnswer!.answer = answerString.clipLastString()
    }
    
}









