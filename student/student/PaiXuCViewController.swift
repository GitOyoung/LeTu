//
//  PaiXuCViewController.swift
//  student
//
//  Created by zhaoheqiang on 15/12/24.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class PaiXuCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    // MARK: propeties
    var question:EtaskQuestion?
    var etaskQuestionOptions = [EtaskQuestionOption]()
    var etaskQuestionOptionTitles = [String]()
    
    @IBOutlet weak var questionTitleView: QuestionTitleView!

    @IBOutlet weak var questionOptionTableView: UITableView!
    
    @IBOutlet weak var answerPadView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(question)
        setQuestionBody(question)
        getEtaskQuestionOptions(question)
        setAnswerButtons()
        questionOptionTableView.delegate = self
        questionOptionTableView.dataSource = self

        questionOptionTableView.setEditing(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: actions 
    
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
    
    //设置题目题干
    func setQuestionBody(question:EtaskQuestion?){
        if let question = question{
            let headerView:UIView = UIView(frame: CGRectMake(0,0,questionOptionTableView!.frame.size.width,60))
            let headerlabel:UILabel = UILabel(frame: headerView.bounds)
            let headerlabeltext = question.questionBody!.dataUsingEncoding(NSUTF8StringEncoding)
            headerlabel.textColor = UIColor.blackColor()
            headerlabel.backgroundColor = UIColor.clearColor()
            headerlabel.font = UIFont.systemFontOfSize(16)
            headerlabel.numberOfLines = 0
            headerlabel.text = (try? NSAttributedString(data: headerlabeltext!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil))?.string
            headerView.addSubview(headerlabel)
            questionOptionTableView?.tableHeaderView = headerView
        }
    
    }
    
    //MARK: 表格代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return etaskQuestionOptionTitles.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "optionCell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let cellText = self.etaskQuestionOptionTitles[indexPath.row].dataUsingEncoding(NSUTF8StringEncoding)
        let attributedString = try? NSAttributedString(data: cellText!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        cell.textLabel?.text = attributedString?.string
        return cell
    }
    

    //隐藏删除按钮
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if sourceIndexPath != destinationIndexPath{
            //获取移动行对应的值
            let itemValue:String = etaskQuestionOptionTitles[sourceIndexPath.row]
            //删除移动的值
            etaskQuestionOptionTitles.removeAtIndex(sourceIndexPath.row)
            //如果移动区域大于现有行数，直接在最后添加移动的值
            if destinationIndexPath.row > etaskQuestionOptionTitles.count{
                etaskQuestionOptionTitles.append(itemValue)
            }else{
                //没有超过最大行数，则在目标位置添加刚才删除的值
                etaskQuestionOptionTitles.insert(itemValue, atIndex:destinationIndexPath.row)
            }
        }
    }
    
    //题目选项实例化
    func getEtaskQuestionOptions(question:EtaskQuestion?){
        if let question = question{
            if let options = question.options{
                for option in options{
                    let etaskQuestionOption = EtaskQuestionOption(option: option)!
                    etaskQuestionOptions.append(etaskQuestionOption)
                    etaskQuestionOptionTitles.append(etaskQuestionOption.option!)
                }
            }
        }
    }

   
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let offsetWidth = Int(screenWidth) - 88
        let offsetHeight = Int(answerPadView.frame.height)
        
        frame.origin.x = CGFloat(offsetWidth/2 - 10)
        frame.origin.y = CGFloat((offsetHeight - 44)/2)
        let submitButton = UIButton(frame: frame)
        submitButton.setTitle("确定", forState: .Normal)
        submitButton.backgroundColor = UIColor.blueColor()
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: "didClickSubmitButton", forControlEvents: UIControlEvents.TouchUpInside)
        frame.origin.x = CGFloat(offsetWidth/2 + 54)
        let cancelButton = UIButton(frame: frame)
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.backgroundColor = UIColor.blueColor()
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: "didClickCancelButton", forControlEvents: UIControlEvents.TouchUpInside)

        answerPadView.addSubview(submitButton)
        answerPadView.addSubview(cancelButton)


    }
    
    func didClickSubmitButton(){
        print("确定")
    }
    
    func didClickCancelButton(){
        print("取消")
    }

}
