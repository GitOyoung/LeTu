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
    @IBOutlet weak var answerArea: UIView!
    
    @IBOutlet weak var answerPad: UIView!
    //可以被选择的对象
    @IBOutlet weak var answerPadOptionsCollectionView: UICollectionView!
    var answerButtonsAry = [UIButton]()
    var answerLabelArray = [UILabel]()
    var buttonNumber = 0
    let optionCellIdentifier = "optionCell"
    var etaskQuestionOptions = [EtaskQuestionOption]()
    
    var answerIndexes:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        setAnswerButtons()
        setAnswerLabels()
        answerPadOptionsCollectionView.dataSource = self
        answerPadOptionsCollectionView.delegate = self
        answerPadOptionsCollectionView.registerNib(UINib(nibName: "XuanzetiankongOptionCell", bundle: nil), forCellWithReuseIdentifier:optionCellIdentifier )
        etaskQuestionOptions = question!.options!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question {
            let url = question.questionBody!
            let attributedStr = htmlFormatString(url)
            buttonNumber = matchStringSymbol(attributedStr)
            questionBodyLabel.text = attributedStr
        }
    }
    
    //MARK:按钮生成
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 44, height: 38)
        for index in 0..<buttonNumber{
            answerIndexes.append("0")
            let button = UIButton(frame: frame)
            frame.origin.x += 54
            button.tag = index
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            button.setTitle("", forState: .Normal)
            button.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forState: .Normal)
            button.backgroundColor = UIColor(red: 240/255.0, green: 239/255.0, blue: 245/255.0, alpha: 1)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor(red: 116/255.0, green: 126/255.0, blue: 136/255.0, alpha: 1).CGColor
            button.layer.cornerRadius = 5
            button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
            
            answerButtonsAry.append(button)
            questionPointView.addSubview(button)
        }
    }
    
    func setAnswerLabels() {
        
        var frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        
        for _ in 0..<buttonNumber {
            let label = UILabel(frame: frame)
            frame.origin.x += 46
            label.font = UIFont.systemFontOfSize(18)
            label.textColor = UIColor(red: 0, green: 0.588, blue: 0.98, alpha: 1) // 0,150,250
            label.textAlignment = .Center
            
            answerLabelArray.append(label)
            answerArea.addSubview(label)
        }
    }
    var buttonIndex: Int = -1
    
    //MARK:选中按钮
    func didClickOptionButton(button:UIButton){
        if buttonIndex == -1 {
            buttonIndex = button.tag
            button.backgroundColor = UIColor(red: 0.471 , green: 0.51, blue: 0.6, alpha: 1)
        } else if buttonIndex == button.tag {
            buttonIndex = -1
            button.backgroundColor = UIColor(red: 0.941, green: 0.937, blue: 0.961, alpha: 1)
        }
        
    }
    
    //MARK UICollectionView相关的方法
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
        let option = etaskQuestionOptions[indexPath.row]
        let optionCell = collectionView.dequeueReusableCellWithReuseIdentifier(optionCellIdentifier, forIndexPath: indexPath) as! XuanzetiankongOptionCell
        optionCell.optionLabel.text = option.option?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " \n"))
        optionCell.layer.cornerRadius = 6
        return optionCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let content = NSString(string: (question?.options![indexPath.row].option?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " \n")))!)
        let width = max(content.boundingRectWithSize(CGSize(width: CGFloat.max,height: 40), options: [.UsesLineFragmentOrigin, .UsesFontLeading] , attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil).size.width, 36)
        let size: CGSize = CGSize(width: width, height: 40)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if buttonIndex >= 0 {
            let option = question?.options![indexPath.row]
            let button = answerButtonsAry[buttonIndex]
            let string = option?.option?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " \n"))
            button.setTitle(string , forState: .Normal)
            answerLabelArray[buttonIndex].text = string
            answerIndexes[buttonIndex] = String((option?.optionIndex)!)
        }
    }
    
    override func loadWithAnswer() {
        if questionAnswer != nil && questionAnswer?.answer != "" {
            let optionIndexs = questionAnswer?.answer.componentsSeparatedByString(",")
            answerIndexes = optionIndexs!
            for (index,number) in (optionIndexs?.enumerate())!{
                for option in etaskQuestionOptions{
                    if String(option.optionIndex!) == number{
                        let button:UIButton = answerButtonsAry[index]
                        button.setTitle(option.option!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " \n")), forState: .Normal)
                    }
                }
            }
        }
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        var answerString:String = ""
        for item in answerIndexes {
            answerString = answerString+"\(item),"
        }
        questionAnswer!.answer = answerString.clipLastString()
    }
}
