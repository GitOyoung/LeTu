//
//  XuanzetiankongViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/16.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class XuanzetiankongViewController: UIViewController {
    
    // MARK properties
    var question:EtaskQuestion?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    //问题以及结果
    @IBOutlet weak var answersCollectionView: UICollectionView!
    
    
    @IBOutlet weak var answerPad: UIView!
    //可以被选择的对象
    @IBOutlet weak var answerPadOptionsCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(question)
        setQuestionBody(question)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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


}
