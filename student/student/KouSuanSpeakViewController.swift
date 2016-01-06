//
//  KouSuanSpeakViewController.swift
//  student
//
//  Created by luania on 16/1/3.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

class KouSuanSpeakViewController: BaseDialogViewController {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var micAnimView: UIView!
    
    var options:[EtaskQuestionOption]!
    var timer:Int!
    var curIndex:Int = 1
    var answers:[String] = []
    var delegate:passAnswerDataDelegate?
    var startTime:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime = NSDate().timeIntervalSince1970
        print("start:\(startTime)")
        contentView.backgroundColor = QKColor.themeBackgroundColor_1()
        micAnimView.layer.cornerRadius = 6
    }
    
    func initData(){
        indexLabel.text = "当前第\(curIndex)题"
        print(curIndex)
        questionBodyLabel.text = htmlFormatString(options[curIndex-1].option!)
        answerLabel.text = ""
    }
    
    @IBAction func speakButtonClicked(sender: UIButton) {
    }
    
    @IBAction func nextButtonClicked(sender: UIButton) {
        let answer = answerLabel.text!
        answers.append(answer)
        if(curIndex == options.count-1){
            sender.setTitle("完成", forState: UIControlState.Normal)
        }
        if(curIndex < options.count){
            curIndex++
            initData()
        }else{
            dismissViewControllerAnimated(true, completion: nil)
            let endTime = NSDate().timeIntervalSince1970
            print("start:\(endTime)")
            let costTime = endTime - startTime
            print(costTime)
            delegate?.passAnswerData(answers, costTime: costTime)
        }
    }
    
}
