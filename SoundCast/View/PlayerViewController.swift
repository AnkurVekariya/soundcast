//
//  PlayerViewController.swift
//  SoundCast
//
//  Created by Ankur on 1/19/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    
    var currentTrackIndex:Int = 0
    var currentAudio = ""
    var player: AVPlayer?
    
    //setup UI
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    
    //viewmodel Int
    var homeViewModels = [HomeViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAudio()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerViewController.finishTrack), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // Prepare audio for playing
    func prepareAudio(){
        
        setCurrentAudioPath()
        
        //verify URL with .mp3 format
        if verifyUrl(urlString: currentAudio){
            
            let audioUrl = NSURL(string: currentAudio)
            
            //check for url is playable or not
            if AVAsset(url: audioUrl! as URL).isPlayable{
               
                playButton.setImage(UIImage(named: "playIcon"), for: UIControl.State.normal)
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                    player = AVPlayer(url: audioUrl! as URL)
                    //player?.play()
                    let _ = player!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] (time) in
                        self!.playerSlider.value = Float(CMTimeGetSeconds(time)) / Float(CMTimeGetSeconds( AVAsset(url: audioUrl! as URL).duration))
                    }
                } catch {
                    print("get player Error = " + "\(error)")
                    if currentTrackIndex >= 0 && currentTrackIndex < homeViewModels.count {
                        currentTrackIndex += 1
                        prepareAudio()
                    }else{
                        currentTrackIndex -= 1
                        prepareAudio()
                    }
                }
            }
            else{
                showAlert(withTitle: "Bad URL", withMessage: "mp3 url is not valid play another track. ")
            }
        }else{
            showAlert(withTitle: "Bad URL", withMessage: "mp3 url is not valid play another track. ")
        }
    }
    
    //verify URL
    func verifyUrl(urlString: String?) -> Bool {
        
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        let trackUrl = URL(string: urlString)
        let fileExtension = trackUrl?.pathExtension // mp3
        if let fileExtension = fileExtension {
            
            if fileExtension == "mp3"{
                return true
            }
            else{
                return false
            }
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    @IBAction func nextButtonTap(_ sender: Any) {
        
        if currentTrackIndex >= 0 &&  currentTrackIndex < homeViewModels.count{
            currentTrackIndex += 1
            prepareAudio()
            playButton.setImage(UIImage(named: "pauseIcon"), for: UIControl.State.normal)
            player?.play()
        }
    }
    
    @IBAction func prevButtonTap(_ sender: Any) {
        
        if currentTrackIndex < homeViewModels.count {
            currentTrackIndex -= 1
            prepareAudio()
            playButton.setImage(UIImage(named: "pauseIcon"), for: UIControl.State.normal)
            player?.play()
        }
    }
    
    @objc func finishTrack()
    {
        //currunt track finished update play button image and reset slider
        playButton.setImage(UIImage(named: "playIcon"), for: UIControl.State.normal)
        playerSlider.value = 0.0
        prepareAudio()

    }
    
    @IBAction func playButtonTap(_ sender: Any) {
        
        if player?.rate != 0 {
            playButton.setImage(UIImage(named: "playIcon"), for: UIControl.State.normal)
            player?.pause()
        }
        else{
            playButton.setImage(UIImage(named: "pauseIcon"), for: UIControl.State.normal)
            player?.play()
        }
    }
    
    //Sets audio file URL
    func setCurrentAudioPath(){
        
        let homeViewModel = homeViewModels[currentTrackIndex]
        DispatchQueue.main.async {
            self.trackImage.layer.cornerRadius = self.trackImage.bounds.size.width / 2.0
            self.trackImage.clipsToBounds = true
        }
        trackTitle?.text = homeViewModel.title
        trackImage.sd_setImage(with: URL(string: homeViewModel.thumbnailURL), placeholderImage: UIImage(named: "trackPlaceholder"))
        
        currentAudio = homeViewModel.link
    }
    
    @IBAction func listButtonTapAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
//string extension for formate check
extension String {

    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        if ext.isEmpty {
            return nil
        }
        return ext
    }
}
//Alertview Extention
extension  UIViewController {
    
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
