//
//  ContentView.swift
//  avfoundationLearn
//
//  Created by Harshit Agarwal on 11/06/24.
//

import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Optionally update the view controller
    }
}

//struct ContentView: View {
//    @State private var check = false
//    @State private var isPlaying = false
//    @State private var currentTime: Double = 0.0
//    @State private var playerVolume: Float = 0.5
//    
//    
//    private var player: AVPlayer
//    private var playerObserver: Any?
//
//    init() {
//            let url = URL(string: "https://events-delivery.apple.com/1505clvgxdwlbjrjhxtjdgcdxaiabvuf/m3u8/vod_index-LHDoZDhTrsKLsbrZKqYpbWraixsWQHkw.m3u8")!
//            self.player = AVPlayer(url: url)
//            self.player.volume = playerVolume
//        }
//    var body: some View {
//        VStack {
//            Button(action: {
//                playVideo()
//            }) {
//                Text("Play Link")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            Button(action: {
//                playLoadedVideo()
//            }) {
//                Text("Play Loaded")
//                    .padding()
//                    .background(check ? Color.red : Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            
//            VideoPlayerView(player: player)
//                            .frame(height: 300)
//                            .cornerRadius(10)
//                            .padding()
//
//                        Button(action: {
//                            isPlaying.toggle()
//                            if isPlaying {
//                                player.play()
//                            } else {
//                                player.pause()
//                            }
//                        }) {
//                            Text(isPlaying ? "Pause Video" : "Play Video")
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
//            
//            Slider(value: $currentTime, in: 0...player.duration, onEditingChanged: { _ in
//                           let targetTime = CMTime(seconds: currentTime, preferredTimescale: 600)
//                           player.seek(to: targetTime)
//                       })
//                       .padding()
//
//            Slider(value: Binding(
//                           get: {
//                               self.playerVolume
//                           },
//                           set: { (newVal) in
//                               self.playerVolume = newVal
//                               self.player.volume = newVal
//                           }
//                       ), in: 0...1)
//                       .padding()
//
//        }
//        .onAppear {
//                    playerObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
//                        currentTime = time.seconds
//                    }
//                }
//        .onDisappear {
//                    if let observer = playerObserver {
//                        player.removeTimeObserver(observer)
//                        playerObserver = nil
//                    }
//                }
//    }
//    
//    
//
//    func playVideo() {
//        guard let url = URL(string: "https://events-delivery.apple.com/1505clvgxdwlbjrjhxtjdgcdxaiabvuf/m3u8/vod_index-LHDoZDhTrsKLsbrZKqYpbWraixsWQHkw.m3u8") else {
//            print("Invalid URL")
//            return
//        }
//
//        let player = AVPlayer(url: url)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let rootViewController = windowScene.windows.first?.rootViewController {
//            rootViewController.present(playerViewController, animated: true) {
//                playerViewController.player?.play()
//            }
//        }
//    }
//    
//    func playLoadedVideo() {
//        guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else {
//            print("Video file not found")
//            check.toggle()
//            return
//        }
//        
//        let url = URL(fileURLWithPath: path)
//        let player = AVPlayer(url: url)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let rootViewController = windowScene.windows.first?.rootViewController {
//            rootViewController.present(playerViewController, animated: true) {
//                playerViewController.player?.play()
//            }
//        }
//    }
//
//}

struct ContentView: View {
    @State private var isPlaying = false
    @State private var currentTime: Double = 0.0
    @State private var playerVolume: Float = 0.5
    private var player: AVPlayer

    private var playerObserver: Any?

    init() {
        let url = URL(string: "https://www.example.com/path/to/your/video.mp4")!
        self.player = AVPlayer(url: url)
    }

    var body: some View {
        VStack {
            VideoPlayerView(player: player)
                .frame(height: 300)
                .cornerRadius(10)
                .padding()

            Button(action: {
                isPlaying.toggle()
                if isPlaying {
                    player.play()
                } else {
                    player.pause()
                }
            }) {
                Text(isPlaying ? "Pause Video" : "Play Video")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            Slider(value: $currentTime, in: 0...(player.currentItem?.duration.seconds ?? 0), onEditingChanged: { _ in
                let targetTime = CMTime(seconds: currentTime, preferredTimescale: 600)
                player.seek(to: targetTime)
            })
            .padding()

            Slider(value: Binding(
                get: {
                    self.player.volume
                },
                set: { (newVal) in
                    self.player.volume = newVal
                }
            ), in: 0...1)
            .padding()
        }
        .onAppear {
            player.volume = playerVolume
            playerObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
                currentTime = time.seconds
            }
        }
        .onDisappear {
            if let observer = playerObserver {
                player.removeTimeObserver(observer)
                playerObserver = nil
            }
        }
    }
}




#Preview {
    ContentView()
}
extension AVPlayer {
    var duration: Double {
        if let currentItem = currentItem {
            return CMTimeGetSeconds(currentItem.asset.duration)
        }
        return 0.0
    }
}
