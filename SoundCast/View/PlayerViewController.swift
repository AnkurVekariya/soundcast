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

  
    
    @IBOutlet var progressTimerLabel : UILabel!
    @IBOutlet var playerProgressSlider : UISlider!
    @IBOutlet var totalLengthOfAudioLabel : UILabel!
    
     var homeViewModels = [HomeViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAudio()
        // Do any additional setup after loading the view.
    }
    
    // Prepare audio for playing
    func prepareAudio(){
        setCurrentAudioPath()

        let audioUrl = NSURL(string: currentAudio)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = AVPlayer(url: audioUrl! as URL)
            player?.play()
        } catch {
            print(error)
        }
      
        
        
    }
    @IBAction func nextButtonTap(_ sender: Any) {
        
        if currentTrackIndex >= 0 {
            
            currentTrackIndex += 1
            setCurrentAudioPath()
        }
    }
    @IBAction func prevButtonTap(_ sender: Any) {
        
        if currentTrackIndex < homeViewModels.count {
            
            currentTrackIndex -= 1
            setCurrentAudioPath()
        }
    }
    
    @IBAction func playButtonTap(_ sender: Any) {
        
        if player?.rate != 0 {
        
            
        }
    }
    
    //Sets audio file URL
    func setCurrentAudioPath(){
        
            let homeViewModel = homeViewModels[currentTrackIndex]
            print("currentIndex is = " + "\(homeViewModel.title)")
            currentAudio = homeViewModel.link

    }
    
    @IBAction func listButtonTapAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
