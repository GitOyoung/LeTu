//  AudioManager.swift
//  Created by oyoung on 15/12/28.
//  Copyright © 2015年 singlu. All rights reserved.

import UIKit
import AudioToolbox
import AVFoundation

protocol AudioManagerDelegate: class
{
    func audioManagerDidStartRecord(recorder: AVAudioRecorder)
    func audioManagerDidEndRecord(recorder: AVAudioRecorder, saved: Bool)
    func audioManager(recorder: AVAudioRecorder, power: Float, currentTime: NSTimeInterval)
    
    func audioManagerDidPrepare(player: AVAudioPlayer, prepared: Bool)
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
    case DoNothingButRecordDone
}

class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer!
    var recorder: AVAudioRecorder!
    var timer: NSTimer?
    
    //url
    var recordUrl: NSURL?
    var playUrls: [NSURL]?
    
    
    var status: ManagerStatus = .DoNothing
    var recordSaved: Bool = false
    
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
    
    
    private override init() {
        super.init()
        setupSettings()
        setupURLs()
        resetManager()
    }
    
    func setupURLs() {
        playUrls = [NSURL]()
    }
    
    func clearUrls() {
        if var urls = playUrls {
            urls.removeAll(keepCapacity: true)
        } else {
            playUrls = [NSURL]()
        }
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
    func startRecordWithFileName(name: String, withExtension ex:String = "aac")
    {
        let strUrl = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let url = NSURL(fileURLWithPath: String(format: "%@/%@.%@", arguments: [strUrl!, name, ex]))
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
            recordSaved = save
            status = save ? .DoNothingButRecordDone : .DoNothing
            if let d = delegate
            {
                d.audioManagerDidEndRecord(self.recorder, saved: save)
            }
        }
    }
    
    func fileExistAtURL(url: NSURL) ->Bool {
        let s = url.absoluteString
        let path = s.substringFromIndex(s.startIndex.advancedBy(7))
        return fileExistAtPath(path)
    }
    func fileExistAtPath(path: String) ->Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func fileExistAtName(name: String, withExtension ex: String = "aac") -> Bool {
        let strUrl = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let url = NSURL(fileURLWithPath: String(format: "%@/%@.%@", arguments: [strUrl!, name, ex]))
        return fileExistAtURL(url)
    }
    
    //播放器相关
    func startPlayWithFileName(name: String, withExtension ex: String = "aac")
    {
        let strUrl = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let url = NSURL(fileURLWithPath: String(format: "%@/%@.%@", arguments: [strUrl!, name, ex]))
        startPlayWithURL(url)
    }
    
    func startPlayWithURL(url: NSURL, complete: (()->Void)? = nil)
    {
        
        if (self.playUrls?.contains(url))! {
            let localPath = url.fileURLToLocalPath()
            let data = NSData(contentsOfFile: localPath)
            startPlayWithData(data!, complete: complete)
        } else {
            
            playUrls?.append(url)
            let path = url.fileURLToLocalPath()
            if fileExistAtPath(path) {
                let data = NSData(contentsOfFile: path)
                startPlayWithData(data!, complete:  complete)
            } else {
                dispatch_async(dispatch_get_global_queue(0, 0)) {
                    let data = NSData(contentsOfURL: url)
                    if !url.absoluteString.hasPrefix("file://") {
                        data?.writeToFile(path, atomically: true)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.startPlayWithData(data!, complete: complete)
                    }
                }
            }
        }
    }
    
    func startPlayWithData(data: NSData, complete: (()->Void)? = nil)
    {
        do
        {
            try audioPlayer = AVAudioPlayer(data: data)
            audioPlayer.delegate = self
            if audioPlayer.prepareToPlay() {
                if let d = delegate {
                    d.audioManagerDidPrepare(audioPlayer, prepared: true)
                }
                if let c = complete {
                    c()
                }
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
    
    func startPlay() {
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
    
    func stopPlay()
    {
        if audioPlayer.playing || audioPlayer != nil {
            audioPlayer.stop()
            playerDidFinishPlaying()
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
        if flag {
            playerDidFinishPlaying()
        }
    }
    
    func playerDidFinishPlaying()
    {
        timer?.invalidate()
        timer = nil
        status = recordSaved ? .DoNothingButRecordDone : .DoNothing
        if let d = delegate {
            d.audioManagerDidEndPlay(audioPlayer)
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

extension NSURL
{
    func fileURLToLocalPath() -> String {
        let local = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let name = fileName()
        return local! + "/" + name!
    }
    
    func fileName() ->String? {
        return self.path?.componentsSeparatedByString("/").last
    }
}



