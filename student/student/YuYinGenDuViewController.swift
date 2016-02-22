//
//  FollowReadingViewController.swift
//  student
//
//  Created by oyoung on 16/1/4.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit
import AVFoundation

class YuYinGenDuViewController: QuestionBaseViewController, AudioProgressViewDelegate, AudioManagerDelegate/* ,AiSpeechEngineDelegate */ {
    
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    @IBOutlet weak var questionBodyLabel: UILabel!
    //听力
    @IBOutlet weak var listenButton: UIButton!
    @IBOutlet weak var listenDurationLabel: UILabel!
    //录音
    @IBOutlet weak var answerCurrentTimeLabel: UILabel!
    @IBOutlet weak var answerProgressContentView: UIPileView!
    @IBOutlet weak var answerDurationLabel: UILabel!
    @IBOutlet weak var answerRecordingView: UIView!
    
    
    weak var listenProgressView: AudioProgressView?
    weak var answerProgressView: AudioProgressView?
    weak var answerProgressButton: UIButton?
    weak var recordButton: ImageButton?
    var audioManager: AudioManager!
    var recordSaved: Bool = false
    
//    var speechEngine: AiSpeechEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setupAudioManager()
        setupListening()
        setupAnswering()
        setupQuestionBody()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let urlString = question?.speechUrlHtmlData {
            if urlString != "" {
                audioManager?.startPlayWithURL(NSURL(string: urlString)!)
            }
        }
    }
    
    func setupListening() {
        listenButton.setImage(UIImage(named: "task_luyin1"), forState: UIControlState.Normal)
        listenButton.tag = 0
        listenButton.addTarget(self, action: Selector("touchDownInside:withEvent:"), forControlEvents: UIControlEvents.TouchDown)
        listenButton.addTarget(self, action: Selector("touchUpInside:withEvent:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupAnswering() {
        
        let progressView = AudioProgressView()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        button.setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
        button.tag = 1
        button.hidden = !recordSaved
        progressView.tag = 1
        progressView.delegate = self
        progressView.updateProgress = 0.0
        progressView.trackTintColor = UIColor.brownColor()
        progressView.progressTintColor = UIColor.blueColor()
        progressView.customView = button
        setupTouchEvent(button)
        answerProgressButton = button
        answerProgressView = progressView
        answerProgressContentView.addSubview(progressView)
        
        setupRecordButton()
    }
    
    
    func setupRecordButton() {
        let frame = answerRecordingView.bounds
        let button = ImageButton(name: "yuyin", withExtension: "gif")
        button.tag = 0
        button.frame = frame
        button.layer.cornerRadius = 6
        button.addTarget(self, action: Selector("recordButtonTouchUpInside:"), forControlEvents: UIControlEvents.TouchUpInside)
        recordButton = button
        answerStatus = recordSaved ? ManagerStatus.DoNothingButRecordDone : ManagerStatus.DoNothing
        answerRecordingView.addSubview(button)
        
    }
    //进度条的点击拖动事件
    func setupTouchEvent(sender: UIControl) {
        sender.addTarget(self, action: Selector("touchDownInside:withEvent:"), forControlEvents: UIControlEvents.TouchDown)
        sender.addTarget(self, action: Selector("touchMoved:withEvent:"), forControlEvents: UIControlEvents.TouchDragInside)
        sender.addTarget(self, action: Selector("touchUpInside:withEvent:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupQuestionBody() {
        if let question = question {
            questionBodyLabel.text = htmlFormatString(question.questionBody!)
        }
    }
    
    func setupSpeechEngine() {
//        let cfg = [NSObject: AnyObject]()
//        //config
//        speechEngine = AiSpeechEngine(cfg: cfg)
//        speechEngine?.delegate = self
    }
    
    
    
    func setupAudioManager() {
        let name = generateName()
        audioManager = AudioManager.shareManager()
        audioManager.resetManager()
        audioManager.delegate = self
        recordSaved = audioManager.fileExistAtName(name)
        if recordSaved {
            audioManager.recordUrl = generateURLWithName(name)
        }
        
    }
    func  generateURLWithName(name: String, withExtension ex: String = "aac") -> NSURL {
        let strUrl = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let url = NSURL(fileURLWithPath: String(format: "%@/%@.%@", arguments: [strUrl!, name, ex]))
        return url
    }
    
    
    func generateName() -> String
    {
        let name = "audio-\((question?.id ?? "null")!)"
        return name
    }
    
    func touchDownInside(sender: UIButton, withEvent ev: UIEvent) {
        if let sv = sender.superview {
            sv.touchesBegan(ev.allTouches()!, withEvent: ev)
        }
    }
    
    func touchMoved(sender: UIButton,  withEvent ev: UIEvent) {
        if let sv = sender.superview {
            sv.touchesMoved(ev.allTouches()!, withEvent: ev)
        }
    }
    
    func touchUpInside(sender: UIButton, withEvent ev: UIEvent) {
        if sender.tag  == 0 { //听力进度条按钮点击
            //需要做得事
            switch listenStatus{
            case .DoNothing, .DoNothingButRecordDone:
                startListening()
            case .Playing:
                pauseListening()
            case .PlayPause:
                resumeListening()
            default:break
            }
        } else {
            //需要做的事
            switch answerStatus{
            case .DoNothing,.DoNothingButRecordDone:
                startPlayAudio()
            case .Playing:
                pausePlayAudio()
            case .PlayPause:
                resumePlayAudio()
            default:break
            }
            
        }
    }
    
    var listenStatus: ManagerStatus = .DoNothing {
        didSet {
            switch listenStatus
            {
            case .Playing, .PlayPause:
                listenProgressView?.interativeEnabled = true
            default:
                listenProgressView?.interativeEnabled = false
            }
        }
    }
    var answerStatus: ManagerStatus = .DoNothing {
        didSet {
            switch answerStatus
            {
            case .Playing, .PlayPause:
                answerProgressView?.interativeEnabled = true
            default:
                answerProgressView?.interativeEnabled = false
            }
        }
    }
    
    func recordButtonTouchUpInside(sender: UIButton) {
        switch answerStatus
        {
        case .DoNothing:
            startRecord()
        case .Recording:
            //弹出提示是否提交或继续录音
            alert("提示", message: "是否提交录音", ok: "提交", cancel: "继续录音"){ self.onAlertOK($0)}
        case .DoNothingButRecordDone:
            //弹出提示是否覆盖
            alert("重新录制语音", message: "确认重新录制语音吗", ok: "确认", cancel: "取消"){self.onAlertOK($0)}
        default:break
        }
    }
    
    func onAlertOK(action: UIAlertAction){
        if action.title == "提交"{
            stopRecord()
        }
        else if action.title == "确认"{
            deleteRecordFile()
            startRecord()
        }
    }
    
    func deleteRecordFile(){
        let path = audioManager.recordUrl?.absoluteString
        do  {
            try NSFileManager.defaultManager().removeItemAtPath(path!)
        } catch {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var listenDuration: NSTimeInterval = 0.0
    var answerDuration: NSTimeInterval = 0.0
    func audioProgressView(progressView: AudioProgressView, progressDidChanged: CGFloat) {
        let ti: NSTimeInterval
        if progressView.tag == 0 { //听力进度
            ti = listenDuration * Double(progressDidChanged)
        } else { //录音播放进度
            ti = answerDuration * Double(progressDidChanged)
        }
        audioManager?.audioPlayer.currentTime = ti
    }
    var playerTagNext: Int = 0
    var playerTag: Int = 0 //0:未播放 1: 表示播放听力，2：表示播放录音
    func audioManagerDidStartPlay(player: AVAudioPlayer) {
        if playerTag == 1 { //听力
            listenStatus = ManagerStatus.Playing
            listenButton?.setImage(UIImage(named: "task_luyin2"), forState: UIControlState.Normal)
        } else if playerTag == 2 {
            answerStatus = ManagerStatus.Playing
            answerProgressButton?.setImage(UIImage(named: "task_stop"), forState: UIControlState.Normal)
            
        }
    }
    
    func audioManagerDidEndPlay(player: AVAudioPlayer) {
        if playerTag == 1 { //听力
            listenStatus = ManagerStatus.DoNothing
            listenProgressView?.updateProgress = 0
            listenButton?.setImage(UIImage(named: "task_luyin1"), forState: UIControlState.Normal)
        } else if playerTag == 2 {
            answerStatus = recordSaved ? ManagerStatus.DoNothingButRecordDone : ManagerStatus.DoNothing
            answerProgressView?.updateProgress = 0
            answerCurrentTimeLabel.text = "00:00"
            answerProgressButton?.setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
        }
        playerTag = 0
    }
    
    func audioManagerDidPause(player: AVAudioPlayer) {
        if playerTag == 1 { //听力
            listenStatus = ManagerStatus.PlayPause
            listenButton?.setImage(UIImage(named: "task_luyin1"), forState: UIControlState.Normal)
        } else if playerTag == 2 {
            answerStatus = ManagerStatus.PlayPause
            answerProgressButton?.setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
        }
    }
    func audioManagerDidResume(player: AVAudioPlayer) {
        if playerTag == 1 { //听力
            listenStatus = ManagerStatus.Playing
            listenButton?.setImage(UIImage(named: "task_luyin2"), forState: UIControlState.Normal)
            
        } else if playerTag == 2 {
            answerStatus = ManagerStatus.Playing
            answerProgressButton?.setImage(UIImage(named: "task_stop"), forState: UIControlState.Normal)
        }
    }
    func audioManager(player: AVAudioPlayer, currentTime: NSTimeInterval, duration: NSTimeInterval) {
        if playerTag == 1 { //听力
            listenDurationLabel.text = currentTime.toStringMMSS()
            listenProgressView?.updateProgress = CGFloat(min((currentTime / duration), 1.0))
        } else if playerTag == 2 {
            answerCurrentTimeLabel.text = currentTime.toStringMMSS()
            answerProgressView?.updateProgress = CGFloat(min((currentTime / duration), 1.0))
        }
    }
    func audioManagerDidPrepare(player: AVAudioPlayer, prepared: Bool) {
        if prepared {
            playerTag = playerTagNext
            if playerTag == 2 {
                answerDuration = player.duration
                answerDurationLabel.text = player.duration.toStringMMSS()
                answerCurrentTimeLabel.text = "00:00"
                
            } else {
                listenDuration = player.duration
                listenDurationLabel.text = player.duration.toStringMMSS()
            }
        }
    }
    
    func audioManager(player: AVAudioPlayer, power: Float) {
        
    }
    
    func audioManagerDidStartRecord(recorder: AVAudioRecorder) {
        answerStatus = ManagerStatus.Recording
        answerDurationLabel.text = "00:00"
        answerCurrentTimeLabel.text = "00:00"
        answerProgressButton?.hidden = true
        recordButton?.startAnimating()
    }
    
    func audioManagerDidEndRecord(recorder: AVAudioRecorder, saved: Bool) {
        answerStatus = saved ? ManagerStatus.DoNothingButRecordDone : ManagerStatus.DoNothing
        recordButton?.stopAnimating()
        answerProgressView?.updateProgress = 0.0
        if saved {
            answerProgressView?.customView?.hidden = false
        }
        
    }
    func audioManager(recorder: AVAudioRecorder, power: Float, currentTime: NSTimeInterval) {
        answerDurationLabel.text = currentTime.toStringMMSS()
        answerProgressView?.updateProgress = CGFloat(min(power, Float(1.0)))
    }
    
    /**
     * 引擎运行完成
     */
    func aiSpeechEngineDidFinishRecording(engine: AiSpeechEngine!, stopType: AIENGINE_STOPTYPE) {
        
    }
    
    /**
     * 引擎收到了json结果
     */
    func aiSpeechEngine(engine: AiSpeechEngine!, didReceive recordId: String!, responseJson jsonString: String!) {
        
    }
    
    //听力部分
    func startListening() {
        if playerTag == 2 { //如果在播放录音，先停止播放录音
            audioManager?.stopPlay()
        }
        playerTagNext = 1
        
        if let urlString = question?.speechUrlHtmlData{
            if urlString != ""{
                audioManager?.startPlayWithURL(NSURL(string: urlString)!) {
                    self.audioManager.startPlay()
                }
            }
        }
    }
    
    func pauseListening() {
        audioManager.pausePlay()
    }
    
    func resumeListening() {
        audioManager.resumePlay()
    }
    
    func stopListening() {
        audioManager.stopPlay()
    }
    
    //录音部分
    func startPlayAudio() {
        if playerTag == 1 { //如果在播放听力，先停止播放听力
            audioManager?.stopPlay()
        }
        playerTagNext = 2
        if let url = audioManager.recordUrl{
            audioManager.startPlayWithURL(url) {
                self.audioManager.startPlay()
            }
        }
    }
    
    func pausePlayAudio() {
        audioManager.pausePlay()
    }
    
    func resumePlayAudio() {
        audioManager.resumePlay()
    }
    
    func stopPlayAudio() {
        audioManager.stopPlay()
    }
    
    func startRecord() {
        let name = "audio-\((question?.id ?? "")!)"
        audioManager?.startRecordWithFileName(name)
        audioManager.startRecord()
    }
    
    func stopRecord(save: Bool = true) {
        recordSaved = save
        audioManager.stopRecordingShouldSave(save)
    }
    
    
}
