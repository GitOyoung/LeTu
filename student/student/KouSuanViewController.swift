//
//  KouSuanViewController.swift
//  student
//
//  Created by luania on 15/12/29.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class KouSuanViewController: QuestionBaseViewController {

    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTitleView.setData(question)
        setQuestionBody(question)
    }
    
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question {
            let questionBody = question.questionBody?.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedStr = try? NSAttributedString(data: questionBody!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType , NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            questionBodyLabel.attributedText = attributedStr
        }
    }
}
