//  AudioManager.swift
//  Created by oyoung on 15/12/28.
//  Copyright © 2015年 singlu. All rights reserved.

import UIKit
import AudioToolbox
import AVFoundation

protocol AudioManagerDelegate
{
    func audioManagerDidStartRecord(recorder: AVAudioRecorder)
    func audioManagerDidEndRecord(recorder: AVAudioRecorder, saved: Bool)
    func audioManager(recorder: AVAudioRecorder, power: Float, currentTime: NSTimeInterval)
    
    
    func audioManagerDidStartPlay(player: AVAudioPlayer)
    func audioManagerDidPause(player: AVAudioPlayer)
    func audioManagerDidResume(player: AVAudioPlayer)
    func audioManagerDidEndPlay(player: AVAudioPlayer)
    func audioManager(player: AVAudioPlayer, power: Float)
    func audioManager(player: AVAudioPlayer, currentTime: NSTimeInterval, duration: NSTimeInterval)
}


enum ManagerStatus
{
    case DoNothing
    case Recording
    case RecordPause
    case Playing
    case PlayPause
}

class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer!
    var recorder: AVAudioRecorder!
    var timer: NSTimer?
    
    //url
    var recordUrl: NSURL?
    var playUrl: NSURL?
    
    
    var status: ManagerStatus = .DoNothing
    
    var settings: [String: NSNumber]?
    var delegate: AudioManagerDelegate?
    
    static var manager: AudioManager? = nil
    class func shareManager() -> AudioManager
    {
        if manager == nil
        {
            manager = AudioManager()
        }
        return manager!
    }
    
    
    override init() {
        super.init()
        setupSettings()
    }
    
    func resetManager()
    {
        switch status
        {
        case .Recording, .RecordPause:
            stopRecordingShouldSave(false)
        case .Playing, .PlayPause:
            stopPlay()
        default:
            break
        }
        
        audioPlayer = nil
        recorder = nil
    }
    
    //录音相关
    
    func setupSettings()
    {
        settings = [
            AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),//编码格式aac
            AVNumberOfChannelsKey : NSNumber(int: 1),//采集音轨
            AVLinearPCMBitDepthKey : NSNumber(int: 16), //线性采样位数
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))//音频质量
        ]
    }
    
    
    //文件名启动录音，默认aac格式， 如果要保存其他格式，请使用 startRecordWithURL方法，并修改自定义设置settings
    func startRecordWithFileName(name: String)
    {
        let strUrl = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let url = NSURL(fileURLWithPath: String(format: "%@/%@.aac", arguments: [strUrl!, name]))
        startRecordWithURL(url)
    }
    //Url启动录音，如果不是aac格式，请再使用此方法之前修改设置参数settings
    func startRecordWithURL(url: NSURL)
    {
        self.recordUrl = url
        do
        {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            try recorder = AVAudioRecorder(URL: url, settings: settings!)
            recorder.meteringEnabled = true
            recorder.delegate = self
        }
        catch
        {
            print("Errors Exsist\(__FILE__): \(__FUNCTION__)")
        }
    }
    
    func startRecord(second s: NSTimeInterval = 0)
    {
        if recorder.prepareToRecord() {
            if s == 0 {
                recorder.record()
            }
            else {
                recorder.recordForDuration(s)
            }
            status = .Recording
            timer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: Selector("detectionVoice"), userInfo: nil, repeats: true)
            delegate?.audioManagerDidStartRecord(recorder)
        }
        
    }
    
    func detectionVoice()
    {
        recorder.updateMeters()
        let lowPassResult: Float = pow(10, 0.05 * recorder.peakPowerForChannel(0))
        if let d = delegate {
            d.audioManager(recorder, power: lowPassResult, currentTime: recorder.currentTime)
        }
    }
    
    
    func pauseRecord()
    {
        if recorder.recording {
            recorder.pause()
            timer?.pause()
            status = .RecordPause
        }
    }
    
    func resumeRecord()
    {
        if !recorder.recording {
            recorder.record()
            timer?.resume()
            status = .Recording
        }
    }
    
    func deleteRecording()
    {
        recorder.deleteRecording()
    }
    
    func stopRecordingShouldSave(save: Bool = true)
    {
        if recorder.recording {
            if !save {
                recorder.deleteRecording()
            }
            recorder.stop()
            timer?.invalidate()
            timer = nil
            status = .DoNothing
            if let d = delegate
            {
                d.audioManagerDidEndRecord(self.recorder, saved: save)
            }
        }
    }
    
    //播放器相关
    func startPlayWithFileName(name: String, withExtension ex: String = "aac")
    {
        let strUrl = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let url = NSURL(fileURLWithPath: String(format: "%@/%@.%@", arguments: [strUrl!, name, ex]))
        startPlayWithURL(url)
    }
    
    func startPlayWithURL(url: NSURL)
    {
        self.playUrl = url
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            let data = NSData(contentsOfURL: url)
            dispatch_async(dispatch_get_main_queue()) {
                self.startPlay(data!)
            }
        }
    }
    
    func startPlay(data: NSData)
    {
        do
        {
            try audioPlayer = AVAudioPlayer(data: data)
            audioPlayer.delegate = self
            if audioPlayer.prepareToPlay()
            {
                audioPlayer.play()
                if delegate != nil
                {
                    delegate?.audioManagerDidStartPlay(audioPlayer)
                }
                
                timer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: Selector("detectionTime"), userInfo: nil, repeats: true)
                status = .Playing
            }
        }
        catch
        {
            print("Errors Exsist\(__FILE__): \(__FUNCTION__)")
        }
    }
    
    func detectionTime()
    {
        audioPlayer.updateMeters()
        let power = pow(10, 0.05 * audioPlayer.peakPowerForChannel(0))
        if let d = delegate
        {
            d.audioManager(audioPlayer, currentTime: audioPlayer.currentTime, duration: audioPlayer.duration)
            d.audioManager(audioPlayer, power: power)
        }
    }
    
  
    
    func stopPlay()
    {
        if audioPlayer.playing {
            audioPlayer.stop()
            timer?.invalidate()
            timer = nil
            status = .DoNothing
        }
    }
    
    func pausePlay()
    {
        if audioPlayer.playing
        {
            audioPlayer.pause()
            timer?.pause()
            status = .PlayPause
            if let d = delegate
            {
                d.audioManagerDidPause(audioPlayer)
            }
            
        }
    }
    
    func resumePlay()
    {
        if !audioPlayer.playing
        {
            audioPlayer.play()
            timer?.resume()
            status = .Playing
            if let d = delegate
            {
                d.audioManagerDidResume(audioPlayer)
            }
        }
    }
    
    func seekToTime(ti: NSTimeInterval)
    {
        audioPlayer.currentTime = ti
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag
        {
            status = .DoNothing
            timer?.invalidate()
            if let d = delegate
            {
                d.audioManagerDidEndPlay(audioPlayer)
            }
            
            
        }
    }
    
  
}

extension NSTimer
{
    
    func pause()
    {
        if valid
        {
            fireDate = NSDate.distantFuture()
        }
    }
    
    func resume()
    {
        if valid
        {
            fireDate = NSDate()
        }
    }
}

