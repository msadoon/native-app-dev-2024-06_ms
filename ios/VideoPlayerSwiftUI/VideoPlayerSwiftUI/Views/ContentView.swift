import SwiftUI
import AVKit
import MarkdownKit

/// Define constants used at the top level of the app's view.
private enum AppConstants {
    struct AppText {
        static let title = "Video Player"
    }
}

/// Top-level view from which all data is passed down view heirarchy.
struct ContentView: View {
    @ObservedObject var dataProvider: VideosDataProvider
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    if let availableVideo = dataProvider.videos.first {
                        VideoPlayer(player: AVPlayer(url: availableVideo.hlsURL))
                        ScrollView {
                            VStack(alignment: .leading) {
                                Text(availableVideo.title)
                                    .fontWeight(.semibold)
                                Text(availableVideo.author.name)
                                    .fontWeight(.light)
                            }
                            .frame(maxWidth: proxy.size.width, alignment: .leading)
                            .padding()
                            
                            Text(dataProvider.attributedStringForMarkdown(text: availableVideo.description))
                                .frame(maxWidth: proxy.size.width, alignment: .leading)
                                .padding()
                        }
                    } else {
                        HStack {
                            Text("No video found")
                        }
                    }
                }
            }
            .task {
                await dataProvider.updateTweets()
            }
            .onReceive(dataProvider.$errorMessage) { _ in
                // TODO: alert user if there is a error in parsing JSON.
            }
            .navigationTitle(AppConstants.AppText.title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

