//
//  TingLiTiankongViewController.swift
//  student
//
//  Created by zjueman on 15/12/27.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
import AVFoundation

class TingLiTiankongViewController: QuestionBaseViewController,AVAudioPlayerDelegate {

    @IBOutlet weak var questionTitleView: QuestionTitleView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var answerPadView: UIView!
    @IBOutlet weak var questionBodyLabel: UILabel!

    @IBOutlet weak var questionAudioView: QuestionAudioView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionTitle(questionTitleView)
        setQuestionBody()
        onSetAudioPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //设置题干
    func setQuestionBody(){
        if let question = question {
            let url = question.questionBody?.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedStr = try? NSAttributedString(data: url!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType , NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            questionBodyLabel.attributedText = attributedStr
        }
    }
    
    //设置声音
    func onSetAudioPlayer(){
        questionAudioView.timer?.invalidate()
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            let url = self.question?.speechUrlHtmlData
            let soundData = NSData(contentsOfURL: NSURL(string: url!)!)
            if let data = soundData{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let player = try? AVAudioPlayer(data: data)
                    self.questionAudioView.audioPlayer = player!
                    print("the player \(player?.duration)")
                    print("the player \(player?.currentTime)")
                    self.questionAudioView.audioPlayer.currentTime = 0
                    self.questionAudioView.totalTime.text = self.timeFormat(self.questionAudioView.audioPlayer.duration)
                    self.questionAudioView.audioPlayer.volume = 1.0
                    self.questionAudioView.audioPlayer.delegate = self
                    self.questionAudioView.audioPlayer.stop()
                    self.questionAudioView.allTime = self.questionAudioView.audioPlayer.duration
                })
            }
        }
        
        
    }

}
