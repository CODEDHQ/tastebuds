//
//  ProfileTableViewCell.swift
//  Tastebuds
//
//  Created by iForsan on 12/7/19.
//  Copyright © 2019 iForsan. All rights reserved.
//

import UIKit
import YoutubePlayerView
import SQLite

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var playerView: YoutubePlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        }
    
    func  prepare(row: Row) {
        
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "origin": "https://youtube.com"
        ]
        
        let url1 = row[url]!.split{$0 == "="}.last.map(String.init)

        playerView.delegate = self
        playerView.loadWithVideoId(url1!, with: playerVars)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ProfileTableViewCell: YoutubePlayerViewDelegate {
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
