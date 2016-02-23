//
//  TingLiTiankongViewController.swift
//  student
//
//  Created by zjueman on 15/12/27.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
import AVFoundation

class TingLiTiankongViewController: QuestionBaseViewController,AudioManagerDelegate,AudioProgressViewDelegate,UITextFieldDelegate {
    
    //MARK:属性
    
    @IBOutlet weak var answerPad: UIView!
    @IBOutlet weak var answerPadWidth: NSLayoutConstraint!
    @IBOutlet weak var answerPadBottom: NSLayoutConstraint!
    @IBOutlet weak var pileView: UIPileView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionTitleView: QuestionTitleView!

    @IBOutlet weak var answerAreaWidth: NSLayoutConstraint!
    @IBOutlet weak var answerArea: UIView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var questionOptions: UILabel!
    var audioManager:AudioManager!
    var duration: NSTimeInterval = 0
    var answerButtonsAry = [UIButton]()
    var answerAry = [UITextField]()
    var buttonNumber = 0
    var isPlaying: Bool = false {
        didSet {
            playingStatusChanged(isPlaying)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioManager = AudioManager.shareManager()
        audioManager.resetManager()
        audioManager.delegate = self
        setQuestionTitle(questionTitleView)
        setQuestionBody()
        setQuestionOptions()
        setContentHeight()
        setAnswerButtons()
        setupProgressView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let url = question?.speechUrlHtmlData
        audioManager.startPlayWithURL(NSURL(string: url!)!, complete: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func setQuestionBody(){
        if let question = question {
            let url = question.questionBody!
            let attributedStr = htmlFormatString(url)
            buttonNumber = self.matchStringSymbol(url)
            questionBodyLabel.text = attributedStr
        }
    }
    
    //TODO: 需要确认一下排序的问题
    func setQuestionOptions(){
        if question!.type == QuestionTypeEnum.TingLiXuanZe{
            var str = ""
            let ary = ["A.","B.","C.","D.","E."]
            if let options = question?.options {
                for (i, v) in options.enumerate() {
                    let attributedString = htmlFormatString(v.option!)
                    str +=  ary[i] + attributedString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
                    
                }
                questionOptions.text = str
            }
        } else {
            questionOptions.hidden = true
        }
        
    }
    
    func setContentHeight() {
        let h =  answerArea.frame.origin.y + answerArea.bounds.height
        scrollContentHeight.constant = h
    }
    
    //选择题选项按钮
    func setAnswerButtons() {
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        if let options = question?.options {
       
            if case QuestionTypeEnum.TingLiXuanZe = question!.type {
                let ary = ["A","B","C","D"]
                let count = options.count
                let w = CGFloat(count * 48 + (count - 1) * 10)
                answerPadWidth.constant = w
                frame.origin.y = (answerPad.bounds.height - 42) / 2
                for i in 0..<count {
                    
                    let button = UIButton(frame: frame)
                    frame.origin.x += 58
                    button.setTitle(ary[i], forState: .Normal)
                    button.backgroundColor = UIColor(red: 0, green: 0.545, blue: 0.94, alpha: 1)
                    button.layer.cornerRadius = 6
                    button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
                    answerButtonsAry.append(button)
                    answerPad.addSubview(button)
                }
            } else {
                let count = buttonNumber
                let w = CGFloat(count * 48 + (count - 1) * 10)
                answerPadWidth.constant = w
                frame.origin.y = (answerPad.bounds.height - 42) / 2
                for i in 0..<count {
                   
                    let textField = UITextField(frame: frame)
                    frame.origin.x += 58
                    textField.tag = i
                    textField.delegate = self
                    textField.borderStyle = UITextBorderStyle.RoundedRect
                    textField.layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).CGColor
                    textField.layer.borderWidth = 2
                    textField.layer.cornerRadius = 6
                    textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                    textField.addTarget(self, action: "didClickOptionTextField:", forControlEvents: UIControlEvents.TouchDown)
                    answerAry.append(textField)
                    answerPad.addSubview(textField)
                }
            }
            
            setAnswerLabels(buttonNumber)
        }
    }
    
    var answerLabelArray: [UILabel] = [UILabel]()
    
    func setAnswerLabels(count: Int) {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        for _ in 0..<count {
            let label = UILabel(frame: frame)
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont.systemFontOfSize(18)
            label.textAlignment = .Left
            label.textColor = UIColor(red: 0, green: 0.544, blue: 0.94, alpha: 1)
            
            answerLabelArray.append(label)
            answerArea.addSubview(label)
        }
    }
    func updateLabelLayout() {
        var frame = CGRectZero
        let w: CGFloat = answerLabelArray.reduce(0) { $0.0 + $0.1.bounds.width }
//        for label in answerLabelArray {
//            w += label.bounds.width
//        }
        
        if w > answerArea.bounds.width { //多行
            for label in answerLabelArray {
                frame.size.width = label.bounds.width
                frame.size.height = label.bounds.height
                label.frame = frame
                frame.origin.y += 30
            }
            answerAreaWidth.constant = CGFloat(answerLabelArray.count * 30)
        } else {
            for label in answerLabelArray {
                frame.size.width = label.bounds.width
                frame.size.height = label.bounds.height
                label.frame = frame
                frame.origin.x += label.bounds.width + 10
            }
            answerAreaWidth.constant = 30
        }
    }
    
    //MARK:选择选项按钮
    func didClickOptionButton(button: UIButton){
        for button in answerButtonsAry{
            button.backgroundColor = UIColor.blueColor()
        }
        button.backgroundColor = UIColor.grayColor()
    }
    
    func didClickOptionTextField(textField:UITextField){
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let textIndex = textField.tag
        let label = answerLabelArray[textIndex]
        label.text = textField.text
        label.sizeToFit()
        updateLabelLayout()
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func loadWithAnswer() {
            if let listAnswer = questionAnswer?.listAnswer {
                if question?.type == QuestionTypeEnum.TingLiTianKong{
                    for (index,answer) in listAnswer.enumerate(){
                        let result = answer as! NSDictionary
                        answerAry[index].text = result["answer"] as? String
                    }
                } else {
                    for (index,answer) in listAnswer.enumerate(){
                        let result = answer as! NSDictionary
                        answerButtonsAry[index].setTitle(result["answer"] as? String, forState: UIControlState.Normal)
                    }
                }
                
                for (i, v) in listAnswer.enumerate() {
                    let r = v as! NSDictionary
                    answerLabelArray[i].text = r["answer"] as? String
                    answerLabelArray[i].sizeToFit()
                }
                updateLabelLayout()
            }
    }

    
    override func updateAnswer() {
        super.updateAnswer()
        var answerArray = [NSDictionary]()
        if let q = question {
            if case .TingLiTianKong = q.type {
                for (i,textField) in answerAry.enumerate(){
                    let dic = getListAnswerItem(textField.text!, answerType: 0, ordinal: i + 1)
                    answerArray.append(dic)
                }
            } else {
                for i in 0..<answerButtonsAry.count {
                    let option = question?.options![i]
                    let dic = getListAnswerItem(String(option?.optionIndex!), answerType: 0, ordinal: i + 1)
                    answerArray.append(dic)
                }
            }
            questionAnswer?.listAnswer = answerArray
        }
        audioManager.resetManager()
    }

    
    private var progressView: AudioProgressView?
    //MARK:设置进度条
    func setupProgressView()
    {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        var frame = pileView.frame
        frame.origin = CGPoint(x: 0, y: 0)
        let audioProgressView = AudioProgressView(frame: frame)
        audioProgressView.customView = button
        audioProgressView.updateProgress = 0.0
        audioProgressView.delegate = self
        audioProgressView.trackTintColor = UIColor.grayColor()
        audioProgressView.progressTintColor = UIColor.blueColor()
        button.tag = 0
        button.userInteractionEnabled = true
        button.hidden = false
        button.setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("touchDownInside:withEvent:"), forControlEvents: UIControlEvents.TouchDown)
        button.addTarget(self, action: Selector("touchMoved:withEvent:"), forControlEvents: UIControlEvents.TouchDragInside)
        button.addTarget(self, action: Selector("audioCtrlClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        progressView = audioProgressView
        pileView.addSubview(audioProgressView)
        isPlaying = false
    }
    
    func playingStatusChanged(isPlay:Bool){
        if isPlay{
            progressView?.interativeEnabled = true
        }else{
            progressView?.interativeEnabled = false
        }
    }
    
    func touchDownInside(button: UIButton, withEvent event: UIEvent)
    {
        if let superView = button.superview{
            superView.touchesBegan(event.allTouches()!, withEvent: event)
        }
    }
    
    func touchMoved(button: UIButton,  withEvent event: UIEvent)
    {
        if let superView = button.superview{
            superView.touchesMoved(event.allTouches()!, withEvent: event)
        }
    }
    
    func audioCtrlClicked(button: UIButton)
    {
        if button.tag == 0 {
           
            if let url = question?.speechUrlHtmlData {
                if url != "" {
                    audioManager.startPlayWithURL(NSURL(string: url)!) {
                        button.tag = 1
                        self.audioManager.startPlay()
                        
                    }
                }
            }
        } else if button.tag == 1 {
            button.tag = 2
            audioManager.pausePlay()
        } else {
            button.tag = 1
            audioManager.resumePlay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func audioManager(player: AVAudioPlayer, power: Float) {
        
    }
    
    func audioManagerDidStartRecord(recorder: AVAudioRecorder) {
        
    }
    
    
    func audioManager(recorder: AVAudioRecorder, power: Float, currentTime: NSTimeInterval) {
        
    }
    
    func audioManagerDidEndRecord(recorder: AVAudioRecorder, saved: Bool) {
        
    }
    
    //播放器委托
    
    func audioManagerDidStartPlay(player: AVAudioPlayer) {
        isPlaying = true
        duration = player.duration
        endLabel.text = timeIntervalToString(duration)
        (progressView?.customView as! UIButton).setImage(UIImage(named: "task_stop"), forState: UIControlState.Normal)
    }
    func audioManagerDidEndPlay(player: AVAudioPlayer) {
        isPlaying = false
        (progressView?.customView as! UIButton).setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
        progressView?.updateProgress = 0.0
        progressView?.customView?.tag = 0
        startLabel.text = "00:00"
    }
    func audioManagerDidPause(player: AVAudioPlayer) {
        (progressView?.customView as! UIButton).setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
    }
    
    func audioManagerDidResume(plaeyer: AVAudioPlayer) {
        (progressView?.customView as! UIButton).setImage(UIImage(named: "task_stop"), forState: UIControlState.Normal)
    }
    
    func audioManager(player: AVAudioPlayer, currentTime: NSTimeInterval, duration: NSTimeInterval) {
        startLabel.text = timeIntervalToString(currentTime)
        progressView?.updateProgress = CGFloat(currentTime / duration)
    }
    
    func audioManagerDidPrepare(player: AVAudioPlayer, prepared: Bool) {
        if prepared {
            endLabel.text = timeIntervalToString(player.duration)
        }
    }

    
    func timeIntervalToString(timer: NSTimeInterval) -> String {
        
        return timer.toStringMMSS()
    }
    
    func audioProgressView(progressView: AudioProgressView, progressDidChanged: CGFloat) {
        let timer = duration * Double(progressView.updateProgress)
        audioManager.seekToTime(timer)
        startLabel.text = timeIntervalToString(timer)
    }
    
    //MARK:键盘弹出
    func keyboardWillShow(notification:NSNotification) {
        if let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            answerPadBottom.constant = -keyboard.height + 50
        }
    }
    
    //MARK:键盘隐藏
    func keyboardWillHide(notification:NSNotification) {
        answerPadBottom.constant = 0
    }
    
    
    
}
