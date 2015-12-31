//
//  ReadingViewController.swift
//  student
//
//  Created by oyoung on 15/12/28.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
import AVFoundation

class ReadingViewController: QuestionBaseViewController, AudioManagerDelegate, AudioProgressViewDelegate
{

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var burlView: UIView!
    @IBOutlet weak var voiceRecordingView: UIView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var progressContentView: UIPileView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var questionTitleView: QuestionTitleView!
    
    var audioManager: AudioManager!
    
    var recordButton: ImageButton?
    
    
    var isPlaying: Bool = false {
        didSet {
            playingStatusChanged(isPlaying)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioManager = AudioManager.shareManager()
        audioManager.delegate = self
        audioManager.resetManager()
        setQuestionTitle(questionTitleView)
        setupTextView()
        setupProgressView()
        setupVoiceRecording()
       
    }
    
    func setupVoiceRecording()
    {
        let frame = voiceRecordingView.bounds
        let button = ImageButton(name: "yuyin", withExtension: "gif")
        button.frame = frame
        button.tag = 0
        button.layer.cornerRadius = 6
        button .addTarget(self, action: Selector("buttonTouchUpInside:"), forControlEvents: UIControlEvents.TouchUpInside)
        recordButton = button
        voiceRecordingView.addSubview(button)
        
    }
    func setupTextView()
    {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0), UIColor(red: 1, green: 1, blue: 1, alpha: 0)]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        textView.contentInset = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 48)
        textView.text = question?.questionBody ?? "没有内容"
        burlView.layer.addSublayer(layer)
    }
    
    private var pView: AudioProgressView?
    
    func setupProgressView()
    {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        var frame = progressContentView.frame
        frame.origin = CGPoint(x: 0, y: 0)
        let pv = AudioProgressView(frame: frame)
        pv.customView = button
        pv.updateProgress = 0.0
        pv.delegate = self
        pv.trackTintColor = UIColor.brownColor()
        pv.progressTintColor = UIColor.blueColor()
        button.tag = 0
        button.userInteractionEnabled = true
        button.hidden = true
        button.setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("touchDownInside:withEvent:"), forControlEvents: UIControlEvents.TouchDown)
        button.addTarget(self, action: Selector("touchMoved:withEvent:"), forControlEvents: UIControlEvents.TouchDragInside)
        button.addTarget(self, action: Selector("audioCtrlClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        pView = pv
        progressContentView.addSubview(pv)
        isPlaying = false
    }
    
    
    func playingStatusChanged(isPlay: Bool)
    {
        if isPlay
        {
            pView?.interativeEnabled = true
        }
        else {
            pView?.interativeEnabled = false
        }
    }
    
    func touchDownInside(sender: UIButton, withEvent ev: UIEvent)
    {
        if let sv = sender.superview
        {
            sv.touchesBegan(ev.allTouches()!, withEvent: ev)
        }
    }
    
    func touchMoved(sender: UIButton,  withEvent ev: UIEvent)
    {
        if let sv = sender.superview
        {
            sv.touchesMoved(ev.allTouches()!, withEvent: ev)
        }
    }
    
    @IBAction func audioCtrlClicked(sender: UIButton)
    {
       let s = sender
        if s.tag == 0 //第一次点击开始播放声音
        {
            s.tag = 1
            startPlay()
            
        }
        else if s.tag == 1 //正在播放时点击暂停播放
        {
            s.tag = 2
            pausePlay()
            
        }
        else //暂停状态点击继续播放
        {
            s.tag = 1
            resumePlay()
          
        }
    }
    
    
    func buttonTouchUpInside(sender: ImageButton)
    {
        let s = sender
        if s.tag == 0 //点击开始录音
        {
            startRecord()
        }
        else if s.tag == 1 //录音期间点击
        {
            //弹出提示是否提交或继续录音
            alert("提示", message: "是否提交录音", ok: "提交", cancel: "继续录音")
        }
        else if s.tag == 2 //录音结束后再次点击
        {
            //弹出提示是否覆盖
            alert("重新录制语音", message: "确认重新录制语音吗", ok: "确认", cancel: "取消")
        }
       
    }
    
    func alert(title: String, message: String, ok: String, cancel: String)
    {
        let avc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            self.onAlertOK(action)
        }
        let cancelAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.Default, handler: nil)
        
        
        avc.addAction(cancelAction)
        avc.addAction(okAction)
        presentViewController(avc, animated: true, completion: nil)
    }
    
    func onAlertOK(action: UIAlertAction)
    {
        if action.title == "提交"
        {
            stopRecord(true)
        }
        else if action.title == "确认"
        {
            deleteRecordFile()
            startRecord()
        }
    }
    
    
    
    func deleteRecordFile()
    {
        let path = audioManager.recordUrl?.absoluteString
        do
        {
            try NSFileManager.defaultManager().removeItemAtPath(path!)
        }
        catch
        {
            
        }
    }
    
    func startRecord()
    {
        let name = "audio-\(question?.id)"
        audioManager.startRecordWithFileName(name)
        audioManager.startRecord()
    }
    
    func stopRecord(save: Bool)
    {
        audioManager.stopRecordingShouldSave(save)
    }
    
    func startPlay()
    {
        if let url = audioManager.recordUrl
        {
            audioManager.startPlayWithURL(url)
        }
    }
    
    func pausePlay()
    {
        audioManager.pausePlay()
    }
    
    func resumePlay()
    {
        audioManager.resumePlay()
    }
    
    func stopPlay()
    {
        audioManager.stopPlay()
    }
    
    
    
    //录音委托
    
    func audioManagerDidStartRecord(recorder: AVAudioRecorder) {
        pView?.customView?.hidden = true
        recordButton?.tag = 1
        currentTimeLabel.text = timeIntervalToString(0)
        durationLabel.text = timeIntervalToString(0)
        recordButton?.startAnimating()
    }
    func audioManagerDidEndRecord(recorder: AVAudioRecorder, saved: Bool) {
        
        if saved {
            recordButton?.tag = 2 //0:没有在录音，也没有录音文件生成；1：正在录音；2:录音停止，有录音文件保存
            pView?.customView?.hidden = false
        }
        else {
            recordButton?.tag = 0
            pView?.customView?.hidden = true
        }
        recordButton?.stopAnimating()
        pView?.updateProgress = 0.0
    }
    func audioManager(recorder: AVAudioRecorder, power: Float, currentTime: NSTimeInterval) {
       
        durationLabel.text = timeIntervalToString(currentTime)
        pView?.updateProgress = CGFloat(min(power, Float(1.0)))
        
    }
   
    //播放器委托
    
    func audioManagerDidStartPlay(player: AVAudioPlayer) {
        isPlaying = true
        duration = player.duration
        durationLabel.text = timeIntervalToString(duration)
        (pView?.customView as! UIButton).setImage(UIImage(named: "task_stop"), forState: UIControlState.Normal)
    }
    func audioManagerDidEndPlay(player: AVAudioPlayer) {
        isPlaying = false
        (pView?.customView as! UIButton).setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
        pView?.updateProgress = 0.0
        pView?.customView?.tag = 0
    }
    func audioManagerDidPause(player: AVAudioPlayer) {
        (pView?.customView as! UIButton).setImage(UIImage(named: "task_play"), forState: UIControlState.Normal)
    }
    
    func audioManagerDidResume(plaeyer: AVAudioPlayer) {
        (pView?.customView as! UIButton).setImage(UIImage(named: "task_stop"), forState: UIControlState.Normal)
    }
    
    func audioManager(player: AVAudioPlayer, currentTime: NSTimeInterval, duration: NSTimeInterval) {
        currentTimeLabel.text = timeIntervalToString(currentTime)
        pView?.updateProgress = CGFloat(currentTime / duration)
    }
    
    func audioManager(player: AVAudioPlayer, power: Float) {
        
    }
    
    
    
    
    
    
    
    
    func timeIntervalToString(ti: NSTimeInterval) -> String
    {
        
        return ti.toStringMMSS()
    }
    
    
    var duration: NSTimeInterval = 0
    
    func audioProgressView(progressView: AudioProgressView, progressDidChanged: CGFloat) {
        let ti = duration * Double(progressView.updateProgress)
        audioManager.seekToTime(ti)
        currentTimeLabel.text = timeIntervalToString(ti)
    }
    
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension NSTimeInterval
{
    func toStringMMSS() -> String
    {
        var second = Int(self)
        let minute = second / 60
        second %= 60
        return "\(minute > 9 ? "" : "0")\(minute):\(second > 9 ? "": "0")\(second)"
    }
}



