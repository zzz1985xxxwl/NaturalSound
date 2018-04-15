//
//  ViewController.swift
//  NaturalSound
//
//  Created by 薛文龙 on 2018/4/15.
//  Copyright © 2018年 com.adrainxue. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    fileprivate var player:AVPlayer = AVPlayer()
    fileprivate var ringPlayer:AVPlayer = AVPlayer()
    fileprivate var isPlaying:Bool = false
    fileprivate var counter:Int = 0
    fileprivate var timer = Timer()
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var txtHour: UILabel!
    @IBOutlet weak var txtMinute: UILabel!
    @IBOutlet weak var txtSecond: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initPlayer(path: Bundle.main.path(forResource: "rain1", ofType:"mp3")!)
        initRing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnPlayDidPress(_ sender: Any) {
        if isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    
    @IBAction func btnResetDidPress(_ sender: Any) {
        self.pause()
        self.resetTimer()
    }
    
    func initRing(){
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ring", ofType:"mp3")!)
        let item = AVPlayerItem(url: url)
        ringPlayer.replaceCurrentItem(with: item)
    }
    
    func initPlayer(path:String){
        let url = URL(fileURLWithPath: path)
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        loopVideo(videoPlayer: player)
    }
    
    func play() {
        player.play()
        btnPlay.setImage(UIImage(named: "pause-white"), for: .normal)
        startTimer()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        btnPlay.setImage(UIImage(named: "play-white"), for: .normal)
        pauseTimer()
        isPlaying = false
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: kCMTimeZero)
            videoPlayer.play()
        }
    }
}
//timer
extension ViewController{
    
    fileprivate func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    fileprivate func pauseTimer() {
        timer.invalidate()
    }
    
    fileprivate func resetTimer() {
        timer.invalidate()
        self.counter = 0
        txtHour.text = "00"
        txtMinute.text = "00"
        txtSecond.text = "00"
    }
    
    fileprivate func getStringFrom(_ time: Int) -> String {
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    @objc fileprivate func UpdateTimer() {
        counter = counter + 1
        let minute = Int((counter % 3600) / 60)
        let second = Int((counter % 3600) % 60)
        let hour = Int(counter / 3600)
        txtHour.text = getStringFrom(hour)
        txtMinute.text = getStringFrom(minute)
        txtSecond.text =  getStringFrom(second)
        
        if(counter % 600 == 0){
            ringPlayer.seek(to: kCMTimeZero)
            ringPlayer.play()
        }
    }
}

