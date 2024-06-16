import Foundation
import SwiftUI
import Alamofire
import MarkdownKit

/// Provide the views with tweets
class VideosDataProvider: ObservableObject {
    let sharedNetworking = Networking()
    private let parser = MarkdownParser()
    @Published var videos = [Video]()
    @Published var errorMessage: String?
    
    /**
     Asynchronously retrieve tweets and pass them along to view.
     
     - Fixme: errors are not handled yet.
     */
    func updateTweets() async {
        let result = await sharedNetworking.retrieveVideoInfo()
        
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                self.videos = data
                self.videos.sort { $0.publishedAt < $1.publishedAt }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func attributedStringForMarkdown(text: String) -> AttributedString {
        AttributedString(parser.parse(text))
    }
}
