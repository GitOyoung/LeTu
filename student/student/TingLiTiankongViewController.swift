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
        let url = "http://7xjubq.com1.z0.glb.clouddn.com/86_qingke_uigesturerecognizer_longpress.mp4"
        let soundData = NSData(contentsOfURL: NSURL(string: url)!)
        let player = try? AVAudioPlayer(data: soundData!)
        questionAudioView.audioPlayer = player!
        print("the player \(player?.duration)")
        print("the player \(player?.currentTime)")
        questionAudioView.audioPlayer.currentTime = 0
        questionAudioView.totalTime.text = timeFormat(questionAudioView.audioPlayer.duration)
        questionAudioView.audioPlayer.volume = 1.0
        questionAudioView.audioPlayer.delegate = self
        questionAudioView.audioPlayer.stop()
        questionAudioView.allTime = questionAudioView.audioPlayer.duration
    }

}
