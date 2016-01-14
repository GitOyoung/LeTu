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
    @IBOutlet weak var pileView: UIPileView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionTitleView: QuestionTitleView!

    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var questionOptions: UILabel!
    var audioManage:AudioManager!
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
        audioManage = AudioManager.shareManager()
        audioManage.delegate = self
        audioManage.resetManager()
        setQuestionTitle(questionTitleView)
        setQuestionBody()
        setQuestionOptions()
        setAnswerButtons()
        setupProgressView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            for (index,option) in (question?.options!.enumerate())!{
                let attributedString = htmlFormatString(option.option!)
                str +=  ary[index] + attributedString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n"
                
            }
            questionOptions.text = str
        }else{
            questionOptions.hidden = true
        }
        
    }
    
    //选择题选项按钮
    func setAnswerButtons(){
        var frame = CGRect(x: 0, y: 0, width: 48, height: 42)
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let options = question?.options!
        let offsetWidth = Int(screenWidth) - (question?.options!.count)!*48
        let offsetHeight = Int(answerPad.frame.height)
        frame.origin.y = CGFloat((offsetHeight-42)/2)
        frame.size.height = CGFloat(offsetHeight/2)
        if question?.type == QuestionTypeEnum.TingLiXuanZe{
            let ary = ["A","B","C","D"]
            for (index,_) in (question?.options!.enumerate())!{
                frame.origin.x = CGFloat((48 + offsetWidth/(options!.count+1))*index + offsetWidth/(options!.count+1))
                let button = UIButton(frame: frame)
                button.setTitle(ary[index], forState: .Normal)
                button.backgroundColor = UIColor.blueColor()
                button.layer.cornerRadius = 5
                button.addTarget(self, action: "didClickOptionButton:", forControlEvents: UIControlEvents.TouchUpInside)
                answerButtonsAry.append(button)
                answerPad.addSubview(button)
            }
        }else{
            let offsetWidth = Int(screenWidth) - buttonNumber*48
            for index in 0..<buttonNumber{
                frame.origin.x = CGFloat((48 + offsetWidth/(buttonNumber+1))*index + offsetWidth/(buttonNumber+1))
                let textField = UITextField(frame: frame)
                textField.delegate = self
                textField.borderStyle = UITextBorderStyle.RoundedRect
                textField.backgroundColor = UIColor.greenColor()
                textField.addTarget(self, action: "didClickOptionTextField:", forControlEvents: UIControlEvents.EditingChanged)
                answerAry.append(textField)
                answerPad.addSubview(textField)
            }
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
        for button in answerButtonsAry{
            button.backgroundColor = UIColor.blueColor()
        }
    }
    
    override func loadWithAnswer() {
            if let listAnswer = questionAnswer?.listAnswer {
                if question?.type == QuestionTypeEnum.TingLiTianKong{
                    for (index,answer) in listAnswer.enumerate(){
                        let result = answer as! NSDictionary
                        answerAry[index].text = result["answer"] as? String
                    }
                }else{
                    for (index,answer) in listAnswer.enumerate(){
                        let result = answer as! NSDictionary
                        answerButtonsAry[index].setTitle(result["answer"] as? String, forState: UIControlState.Normal)
                    }
                }
            }
    }

    
    override func updateAnswer() {
        var answerArray = [NSDictionary]()

        if question?.type == QuestionTypeEnum.TingLiTianKong{
            for (index,textField) in answerAry.enumerate(){
                let dic = getListAnswerItem(textField.text!, answerType: 0, ordinal: index)
                answerArray.append(dic)
            }
        }else{
            for (index,_) in answerButtonsAry.enumerate(){
                let option = question?.options![index]
                let dic = getListAnswerItem(String(option?.optionIndex!), answerType: 0, ordinal: index)
                answerArray.append(dic)
            }
        }
        questionAnswer?.listAnswer = answerArray
    }
    
    
    //MARK:答案处理
//    func answerFormat(answerArray:[AnyObject])-> NSArray{
//        var answerArray = [NSDictionary]()
//        var dic = NSDictionary()
//        for (index,answer) in answerArray.enumerate(){
//            if question?.type == QuestionTypeEnum.TingLiTianKong{
//                let result = answer as! UITextField
//                dic = getListAnswerItem(result.text!, answerType: 0, ordinal: index)
//            }else{
//                let option = question?.options![index]
//                dic = getListAnswerItem(String(option?.optionIndex!), answerType: 0, ordinal: index)
//            }
//            answerArray.append(dic)
//        }
//        return answerArray
//    }

    
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
        if button.tag == 0{
            button.tag = 1
            if let url = question?.speechUrlHtmlData {
                if url != "" {
                    audioManage.startPlayWithURL(NSURL(string: url)!) {
                        self.audioManage.startPlay()
                    }
                }
            }
        }
        else if button.tag == 1 {
            button.tag = 2
            audioManage.pausePlay()
        }
        else{
            button.tag = 1
            audioManage.resumePlay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

    
    func timeIntervalToString(timer: NSTimeInterval) -> String{
        
        return timer.toStringMMSS()
    }
    
    func audioProgressView(progressView: AudioProgressView, progressDidChanged: CGFloat) {
        let timer = duration * Double(progressView.updateProgress)
        audioManage.seekToTime(timer)
        startLabel.text = timeIntervalToString(timer)
    }
    
    //MARK:键盘弹出
    func keyboardWillShow(notification:NSNotification){if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect = CGRectMake(0.0, -200,width,height);
        self.view.frame = rect
        }
    }
    
    //MARK:键盘隐藏
    func keyboardWillHide(notification:NSNotification){
        self.view.addSubview(answerPad)
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect = CGRectMake(0.0, 0,width,height);
        self.view.frame = rect
    }
    
}
