import Foundation
import SwiftUI
import Alamofire

/// Provide the views with tweets
class VideosDataProvider: ObservableObject {
    let sharedNetworking = Networking()
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
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
