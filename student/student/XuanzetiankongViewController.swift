//
//  XuanzetiankongViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/16.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class XuanzetiankongViewController: QuestionBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    //问题以及结果
    @IBOutlet weak var questionPointView: UIView!
    
    @IBOutlet weak var answerPad: UIView!
    //可以被选择的对象
    @IBOutlet weak var answerPadOptionsCollectionView: UICollectionView!
    
    let optionCellIdentifier = "optionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(question)
        setQuestionBody(question)
        answerPadOptionsCollectionView.dataSource = self
        answerPadOptionsCollectionView.delegate = self
        answerPadOptionsCollectionView.registerNib(UINib(nibName: "XuanzetiankongOptionCell", bundle: nil), forCellWithReuseIdentifier:optionCellIdentifier )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // MARK UICollectionView相关的方法
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let question = question {
            if let options = question.options {
                print("选择填空：共有\(options.count)个选项")
                return options.count
            } else {
                print("问题\(question.id)没有options")
                return 0
            }
        } else {
            print("没有问题，所以没有options")
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let doHaveQuestion = question!
        let doHaveptions = doHaveQuestion.options!
        
        let option = doHaveptions[indexPath.row]
        let optionCell = collectionView.dequeueReusableCellWithReuseIdentifier(optionCellIdentifier, forIndexPath: indexPath) as! XuanzetiankongOptionCell
        optionCell.optionLabel.text = option.option
        optionCell.optionLabel.sizeToFit()
        return optionCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let doHaveQuestion = question!
        let doHaveptions = doHaveQuestion.options!
        let option = doHaveptions[indexPath.row]
        let myString: NSString = option.option! as NSString
        var size: CGSize = myString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
        size.height = 50
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }

}
