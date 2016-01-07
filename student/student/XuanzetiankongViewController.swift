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
    var answerButtonsAry = [UIButton]()
    var buttonNumber = 0
    var buttonAry = [AnyObject]()
    let optionCellIdentifier = "optionCell"
    
    var answerIndexes:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        setAnswerButtons()
        answerPadOptionsCollectionView.dataSource = self
        answerPadOptionsCollectionView.delegate = self
        answerPadOptionsCollectionView.registerNib(UINib(nibName: "XuanzetiankongOptionCell", bundle: nil), forCellWithReuseIdentifier:optionCellIdentifier )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question {
            let url = question.questionBody?.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedStr = try? NSAttributedString(data: url!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType , NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            buttonNumber = matchStringSymbol((attributedStr?.string)!)
            questionBodyLabel.attributedText = attributedStr
        }
    }
    
    //MARK:按钮生成
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        let viewWidth = UIScreen.mainScreen().bounds.width
        let offsetWidth = Int(viewWidth) - buttonNumber*48
        for index in 0..<buttonNumber{
            answerIndexes.append(0)
            frame.origin.x = CGFloat((48 + offsetWidth/(buttonNumber+1))*index + offsetWidth/(buttonNumber+1))
            frame.origin.y = 48
            frame.size.height = 48
            
            let button = UIButton(frame: frame)
            button.setTitle("", forState: .Normal)
            button.backgroundColor = UIColor.blueColor()
            button.layer.cornerRadius = 5
            button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
            
            answerButtonsAry.append(button)
            questionPointView.addSubview(button)
        }
    }
    
    //MARK:选中按钮
    func didClickOptionButton(button:UIButton){
        buttonAry.removeAll(keepCapacity: true)
        let buttonIndex = answerButtonsAry.indexOf(button)
        for (index,button) in answerButtonsAry.enumerate(){
            if buttonIndex == index{
                button.backgroundColor = UIColor.grayColor()
                buttonAry.append([button,true])
            }else{
                button.backgroundColor = UIColor.blueColor()
                buttonAry.append([button,false])
            }
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
        size.width = 50
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let option = question?.options![indexPath.row]
        for index in 0..<buttonAry.count{
            let ary = buttonAry[index] as! NSArray
            if ary.lastObject! as! Bool{
                let button = ary.firstObject as! UIButton
                button.setTitle(option?.option, forState: .Normal)
                answerIndexes[index] = (option?.optionIndex)!
                print(answerIndexes)
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
