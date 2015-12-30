//
//  QuestionAudioView.swift
//  student
//
//  Created by zhaoheqiang on 15/12/28.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
import AVFoundation

class QuestionAudioView: UIView ,AVAudioPlayerDelegate{
    let startTime:UILabel = UILabel()
    let totalTime:UILabel = UILabel()
    let audioProgressView = UIProgressView()
    let startButton:UIButton = UIButton()
    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    var timer:NSTimer?
    var allTime:NSTimeInterval?
    
    let labelHeight = 20
    let labelWidth = 47
    let labelY = 10
    let labelX = 10
    let startImage:UIImage = UIImage(named: "startPlay")!
    let stopImage:UIImage = UIImage(named: "stopPlay")!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        startTime.text = "00:00"
        startTime.textAlignment = .Center
        addSubview(startTime)
        
        audioProgressView.setProgress(0, animated: true)
        addSubview(audioProgressView)
        
        startButton.setImage(startImage, forState: .Normal)
        startButton.addTarget(self, action: "didClickButton", forControlEvents: .TouchUpInside)
        addSubview(startButton)
        
        totalTime.text = "00:00"
        totalTime.textAlignment = .Center
        addSubview(totalTime)
    }
    
    override func layoutSubviews() {

        let screenWidth = UIScreen.mainScreen().bounds.width
        startTime.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        let allLabelWidth = CGFloat(labelX*2+labelWidth)
        
        startButton.frame = CGRect(x: allLabelWidth - startImage.size.width/2, y: CGFloat(labelY), width: CGFloat(labelWidth), height: CGFloat(labelHeight))
        
        audioProgressView.frame = CGRect(x: allLabelWidth, y: CGFloat(labelY*2), width: CGFloat(screenWidth-2*allLabelWidth), height: CGFloat(2))
        
        totalTime.frame = CGRect(x: screenWidth-allLabelWidth+CGFloat(labelX), y: CGFloat(labelY), width: CGFloat(labelWidth), height: CGFloat(labelHeight))
        
    }
   
    func didClickButton(){
        if isPlaying {
            isPlaying = false
            timer?.invalidate()
            startButton.setImage(startImage, forState: .Normal)
            audioPlayer.stop()
        }else{
            isPlaying = true
            startButton.setImage(stopImage, forState: .Normal)
            audioPlayer.play()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        }
    }
    
    //计算时间
    func updateTime() {
        let nowTime = audioPlayer.currentTime
        if nowTime > 0.0 {
            let progressPre = nowTime/allTime!
            audioProgressView.progress = Float(progressPre)
            startButton.frame.origin.x = CGFloat(labelX*2+labelWidth) - startImage.size.width/2 + CGFloat(progressPre)*CGFloat(labelX*2 + labelWidth)
        }
        startTime.text = timeFormat(audioPlayer.currentTime)
    }
    
    //MARK: time format
    func timeFormat(time:NSTimeInterval)->String{
        let currentTime = Int(time)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        let timeStr = NSString(format: "%02d:%02d", minutes,seconds) as String
        return timeStr
    }

}
