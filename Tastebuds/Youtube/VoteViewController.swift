//
//  VoteViewController.swift
//  Tastebuds
//
//  Created by iForsan on 12/6/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit
import YoutubePlayerView
import SQLite

class VoteViewController: UIViewController {
    
    //    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var playerView: YoutubePlayerView!
    @IBOutlet weak var playerView2: YoutubePlayerView!
    
    @IBOutlet weak var voteView: UILabel!
    
    @IBOutlet weak var voteCount1: UILabel!
    @IBOutlet weak var owner1: UILabel!
    
    @IBOutlet weak var voteCount2: UILabel!
    @IBOutlet weak var owner2: UILabel!
    
    @IBOutlet weak var owner1Button: UIButton!
    @IBOutlet weak var owner2Button: UIButton!
    
    @IBAction func owner2ButtonAction(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        controller?.user = video2?[username]
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func owner1Button(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        controller?.user = video1?[username]
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    var isPanGestureIdentified = false
    var orginalPoint: CGPoint!
    
    var video1: Row?
    var video2: Row?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reset()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragAvatar(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        panGesture.cancelsTouchesInView = true
        voteView.addGestureRecognizer(panGesture)
        
//        let panGesture2 = UIPanGestureRecognizer(target: self, action: #selector(dragAvatarPlayer2(_:)))
//        panGesture2.maximumNumberOfTouches = 1
//        panGesture2.minimumNumberOfTouches = 1
//        panGesture2.cancelsTouchesInView = true
//        voteView.addGestureRecognizer(panGesture2)
    }
    
    func reset() {
        prepareVideos()
        
        voteCount1.isHidden = true
        owner1.isHidden = true
        
        voteCount2.isHidden = true
        owner2.isHidden = true
    }

    
    fileprivate func prepareVideos() {
        // Do any additional setup after loading the view.
        
        let videos = db.selectVides(catIdValue: selectedCatId)
        
        video1 = videos?.randomElement()
        video2 = db.selectVideo(urlValue: video1![url]!)
        
        let url1 = video1![url]?.split{$0 == "="}.last.map(String.init)
        let url2 = video2![url]?.split{$0 == "="}.last.map(String.init)

        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "origin": "https://youtube.com"
        ]
        playerView.delegate = self
        playerView.loadWithVideoId(url1!, with: playerVars)
        
        let playerVars2: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "origin": "https://youtube.com"
        ]
        playerView2.delegate = self
        playerView2.loadWithVideoId(url2!, with: playerVars2)
        
        voteView.layer.cornerRadius = voteView.frame.height / 2
        voteView.layer.borderWidth = 1
        voteView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func playAgainAction(_ sender: Any) {
        
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)

        voteView.backgroundColor = overcastBlueColor
        voteView.isUserInteractionEnabled = true
        
        reset()
    }
    
    @IBAction func startOverAction(_ sender: Any) {
        
        let index = navigationController!.viewControllers.count - 2
        let controller = navigationController!.viewControllers[index]
        navigationController?.popToViewController(controller, animated: false)
    }
}

extension VoteViewController: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.fetchPlayerState { (state) in
            print("Fetch Player State: \(state)")
        }
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }
}

extension VoteViewController {
    
    @objc func dragAvatar(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            
            isPanGestureIdentified = true
            orginalPoint = voteView.frame.origin
        }
        
        if !isPanGestureIdentified {
            return
        }
        
        let translatedPoint = sender.translation(in: voteView.superview!)
        let translateX = orginalPoint.x + translatedPoint.x
        let translateY = orginalPoint.y + translatedPoint.y
        
        let container = playerView.superview!
        let rect = voteView.superview!.convert(voteView.frame, to: container)

        let container2 = playerView2.superview!
        let rect2 = voteView.superview!.convert(voteView.frame, to: container2)
        
        if sender.state == .changed {
            voteView.frame.origin = CGPoint(x: translateX, y: translateY)
            
            if playerView.frame.intersection(rect).isNull {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.playerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.playerView.layer.removeAllAnimations()
                })
                
            } else {
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.2
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: playerView.center.x - 10, y: playerView.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: playerView.center.x + 10, y: playerView.center.y))
                
                playerView.layer.add(animation, forKey: "position")
            }
            
            if playerView2.frame.intersection(rect2).isNull {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.playerView2.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.playerView2.layer.removeAllAnimations()
                })
                
            } else {
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.2
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: playerView2.center.x - 10, y: playerView2.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: playerView2.center.x + 10, y: playerView2.center.y))
                
                playerView2.layer.add(animation, forKey: "position")

            }
        }
        
        
        if sender.state == .ended || sender.state == .cancelled || sender.state == .failed {
            
            
            isPanGestureIdentified = false
            orginalPoint = CGPoint.zero
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.voteView.frame = self.voteView.superview!.bounds
            }, completion: nil)
            
            playerView.layer.removeAllAnimations()
            playerView2.layer.removeAllAnimations()

            if playerView.frame.intersection(rect).isNull {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.playerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
                
            } else {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.playerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
                
                showResult(player: 1)
            }
            
            if playerView2.frame.intersection(rect).isNull {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.playerView2.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
                
            } else {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.playerView2.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
                showResult(player: 2)
            }
        }
    }
    
    
    @objc func openProfile(user: String) {
        
    }
    
    func showResult(player: Int) {
        
        let value1 = video1![voteCount] + (player == 1 ? 1 : 0)
        voteCount1.text = "Vote count for this video: " + value1.description
        owner1.text = "This video was posted by:" + video1![username]!
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(openProfile(user:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        panGesture.cancelsTouchesInView = true
        owner1.addGestureRecognizer(panGesture)
        owner1.tag = 1
        
        let value2 = video2![voteCount] + (player == 2 ? 1 : 0)
        voteCount2.text = "Vote count for this video: " + value2.description
        owner2.text = "This video was posted by:" + video2![username]!
        
        let panGesture2 = UIPanGestureRecognizer(target: self, action:  #selector(openProfile(user:)))
        panGesture2.maximumNumberOfTouches = 1
        panGesture2.minimumNumberOfTouches = 1
        panGesture2.cancelsTouchesInView = true
        owner2.addGestureRecognizer(panGesture2)
        owner2.tag = 2

        if player == 1 {
            
            voteCount1.isHidden = false
            owner1.isHidden = false
            
            db.updateVideoCounter(urlValue: video1![url]!, voteCountValue: value1)
            
            voteCount2.isHidden = false
            owner2.isHidden = false
            
        } else {
            
            voteCount1.isHidden = false
            owner1.isHidden = false
            
            voteCount2.isHidden = false
            owner2.isHidden = false
            

            db.updateVideoCounter(urlValue: video2![url]!, voteCountValue: value2)
        }
        
        voteView.backgroundColor = UIColor.darkGray
        voteView.isUserInteractionEnabled = false
    }
}

