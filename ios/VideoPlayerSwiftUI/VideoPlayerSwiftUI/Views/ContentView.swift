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
    @State private var hoveringOverVideo = true
    @ObservedObject var dataProvider: VideosDataProvider
    var videoController = AVPlayerControllerRepresented(player: AVPlayer(url: URL.init(string: "https://")!))
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    if let availableVideo = dataProvider.currentVideo {
                        videoController
                            .onAppear {
                                videoController.setItemToPlay(url: availableVideo.hlsURL)
                            }
                            .overlay {
                                HStack {
                                    Image("previous")
                                        .onTapGesture {
                                            dataProvider.previousItem()
                                        }
                                    if !videoController.isPlaying {
                                        Image("play")
                                            .onTapGesture {
                                                videoController.play()
                                            }
                                    } else {
                                        Image("pause")
                                            .onTapGesture {
                                                videoController.pause()
                                            }
                                    }
                                    
                                    Image("next")
                                        .onTapGesture {
                                            dataProvider.nextItem()
                                        }
                                }
                            }
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
                await dataProvider.retrieveVideos()
            }
            .onReceive(dataProvider.$errorMessage) { _ in
                // TODO: alert user if there is a error in parsing JSON.
            }
            .navigationTitle(AppConstants.AppText.title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

