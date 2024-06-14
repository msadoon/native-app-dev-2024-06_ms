import Foundation
import SwiftUI

@main
struct VideoPlayerSwiftUIApp: App {
    let videosDataProvider = VideosDataProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView(dataProvider: videosDataProvider)
        }
    }
}
