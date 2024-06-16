import Foundation
import SwiftUI
import Alamofire
import MarkdownKit

/// Provide the views with tweets
class VideosDataProvider: ObservableObject {
    let sharedNetworking = Networking()
    private let parser = MarkdownParser()
    private var allVideos = [Video]()
    private var currentVideoIndex = 0
    @Published var currentVideo: Video?
    @Published var errorMessage: String?
    
    /**
     Asynchronously retrieve videos and pass them along to view.
     
     - Fixme: errors are not handled yet.
     */
    func retrieveVideos() async {
        let result = await sharedNetworking.retrieveVideoInfo()
        
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                self.allVideos = data
                self.allVideos.sort { $0.publishedAt < $1.publishedAt }
                self.currentVideo = self.allVideos.first
                self.currentVideoIndex = 0
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func nextItem() {
        self.currentVideoIndex = self.currentVideoIndex < self.allVideos.count - 1 ? self.currentVideoIndex + 1 : 0
        self.currentVideo = self.allVideos[currentVideoIndex]
    }
    
    func previousItem() {
        self.currentVideoIndex = self.currentVideoIndex > 0 ? self.currentVideoIndex - 1 : self.allVideos.count - 1
        self.currentVideo = self.allVideos[currentVideoIndex]
    }
    
    func attributedStringForMarkdown(text: String) -> AttributedString {
        AttributedString(parser.parse(text))
    }
}
