import UIKit
import SwiftUI
import AVKit

struct AVPlayerControllerRepresented: UIViewControllerRepresentable {
    var player = AVPlayer()
    let controller = AVPlayerViewController()
    var isPlaying = false
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.player = player
        controller.showsPlaybackControls = false
    
        return controller
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func setItemToPlay(url: URL) {
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        controller.player = player
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        /**TODO: Used in delegate for controller**/
    }
}
