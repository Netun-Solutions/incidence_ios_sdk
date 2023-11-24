//
//  YoutubeViewController.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 13/7/22.
//

import UIKit
import WebKit
import youtube_ios_player_helper

class YoutubeViewController: IABaseViewController {

    private var viewModel: YoutubeViewModel! { get { return baseViewModel as? YoutubeViewModel }}
    
    init(viewModel: YoutubeViewModel) {
        super.init(nibName: nil, bundle: nil)
        baseViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var videoView: YTPlayerView = {
        //let video = YTPlayerView.init(frame: UIScreen.main.bounds)
        
//        let frame = CGRect(0,0,UIScreen.main.bounds.size.width,UIScreen.main.bounds.size.height/2);
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3);
        let video = YTPlayerView.init(frame: frame)
        video.delegate = self
        let code = viewModel.code
        //video.load(withVideoId: code, playerVars: ["autoplay": 1, "playsinline":"0", "modestbranding":"0", "version":"5"])
        video.load(withVideoId: code)
        return video
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        AppNavigation.setupNavigationApperance(navigationController!, with: .regular)
        self.loadWebsite()
        view.backgroundColor = UIColor.app(.incidence100)
    }
    
    func loadWebsite() {
        view.addSubview(self.videoView)
    }
}

extension YoutubeViewController: YTPlayerViewDelegate{
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .buffering{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if state == .buffering{
                    playerView.playVideo()
                }
            }
        } else if state == .ended {
            //playerView.seek(toSeconds: 0, allowSeekAhead: false);
            //playerView.pauseVideo();
            playerView.cueVideo(byId: viewModel.code, startSeconds: 0);
        }
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
