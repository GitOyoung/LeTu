//
//  PaiXuCViewController.swift
//  student
//
//  Created by zhaoheqiang on 15/12/24.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class PaiXuCViewController: QuestionBaseViewController,UITableViewDelegate,UITableViewDataSource {
   
    // MARK: propeties
    var etaskQuestionOptions = [EtaskQuestionOption]()
    var cellTotalHeight:CGFloat = 0
    var answerButtons = [UIButton]()
    
    @IBOutlet weak var questionTitleView: QuestionTitleView!

    @IBOutlet weak var questionOptionTableView: UITableView!
    
    @IBOutlet weak var answerPadView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody(question)
        etaskQuestionOptions = (question?.options!)!
        setAnswerButtons()
        questionOptionTableView.delegate = self
        questionOptionTableView.dataSource = self
        questionOptionTableView.setEditing(true, animated: true)
        questionOptionTableView.scrollEnabled = false
        setScrollEable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: actions
    //设置题目题干
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question{
            let headerView:UIView = UIView(frame: CGRectMake(0,0,questionOptionTableView!.frame.size.width,60))
            let headerlabel = UILabel(frame: CGRect(x: 48, y: 0, width: headerView.bounds.width, height: headerView.bounds.height))
            let headerlabeltext = question.questionBody!.dataUsingEncoding(NSUTF8StringEncoding)
            headerlabel.textColor = UIColor.blackColor()
            headerlabel.backgroundColor = UIColor.clearColor()
            headerlabel.font = UIFont.systemFontOfSize(16)
            headerlabel.numberOfLines = 0
            headerlabel.text = (try? NSAttributedString(data: headerlabeltext!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil))?.string
            headerView.addSubview(headerlabel)
            cellTotalHeight += headerView.frame.size.height
            questionOptionTableView?.tableHeaderView = headerView
        }
    
    }
    
    //MARK: 表格代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return etaskQuestionOptions.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "optionCell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let cellText = self.etaskQuestionOptions[indexPath.row].option!.dataUsingEncoding(NSUTF8StringEncoding)
        let attributedString = try? NSAttributedString(data: cellText!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        cell.textLabel?.text = attributedString?.string
        cell.textLabel?.sizeToFit()
        cellTotalHeight += (cell.textLabel?.frame.size.height)!
        return cell
    }

    //隐藏删除按钮
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if sourceIndexPath != destinationIndexPath{
            //获取移动行对应的值
            let itemValue:EtaskQuestionOption = etaskQuestionOptions[sourceIndexPath.row]
            //删除移动的值
            etaskQuestionOptions.removeAtIndex(sourceIndexPath.row)
            //如果移动区域大于现有行数，直接在最后添加移动的值
            if destinationIndexPath.row > etaskQuestionOptions.count{
                etaskQuestionOptions.append(itemValue)
            }else{
                //没有超过最大行数，则在目标位置添加刚才删除的值
                etaskQuestionOptions.insert(itemValue, atIndex:destinationIndexPath.row)
            }
        }
    }
   
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let offsetWidth = Int(screenWidth) - 96
        let offsetHeight = Int(answerPadView.frame.height)
        
        frame.origin.x = CGFloat(offsetWidth/2 - 10)
        frame.origin.y = CGFloat((offsetHeight - 42)/2)
        let submitButton = UIButton(frame: frame)
        submitButton.setTitle("确定", forState: .Normal)
        submitButton.backgroundColor = UIColor(red: 0, green: 150/255.0, blue: 250/255.0, alpha: 1)
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: "didClickSubmitButton:", forControlEvents: UIControlEvents.TouchUpInside)
        frame.origin.x = CGFloat(offsetWidth/2 + 58)
        answerButtons.append(submitButton)
        let cancelButton = UIButton(frame: frame)
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.backgroundColor = UIColor(red: 0, green: 150/255.0, blue: 250/255.0, alpha: 1)
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: "didClickCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
        answerButtons.append(cancelButton)
        answerPadView.addSubview(submitButton)
        answerPadView.addSubview(cancelButton)
        answerPadView.hidden = true


    }
    
    func didClickSubmitButton(button:UIButton){
        changeButtonBackground()
        button.backgroundColor = UIColor.blueColor()
        print("确定")
    }
    
    func didClickCancelButton(button:UIButton){
        changeButtonBackground()
        button.backgroundColor = UIColor.blueColor()
        print("取消")
    }
    
    //改变按钮颜色
    func changeButtonBackground(){
        for button in answerButtons{
            button.backgroundColor = UIColor(red: 0, green: 150/255.0, blue: 250/255.0, alpha: 1)
        }
    }
    
    //判断scrollView是否允许滚动
    func setScrollEable(){
        let screenHeight = UIScreen.mainScreen().bounds.height
        let offsetHeight = screenHeight - 98 - questionTitleView.frame.size.width - answerPadView.frame.size.height
        if offsetHeight > cellTotalHeight{
            scrollView.scrollEnabled = false
        }

    }
    
    override func loadWithAnswer() {
        if questionAnswer != nil && questionAnswer?.answer != "" {
            print("paixu")
            let optionIndexs = questionAnswer?.answer.componentsSeparatedByString(",")
            print(optionIndexs)
            for option in etaskQuestionOptions{
                for (index,number) in (optionIndexs?.enumerate())!{
                    if option.optionIndex == Int(number){
                        etaskQuestionOptions[index] = option
                    }
                }
            }
        }
    }
    
    override func updateAnswer() {
        super.updateAnswer()
        var answerString:String = ""
        for option in etaskQuestionOptions {
            answerString = answerString+"\(option.optionIndex!),"
        }
        questionAnswer!.answer = answerString.clipLastString()
    }
}





