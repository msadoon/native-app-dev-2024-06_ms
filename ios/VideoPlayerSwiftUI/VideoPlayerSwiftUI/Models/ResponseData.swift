import Foundation

/// All tweets in timeline.
struct ResponseData: Decodable {
    let videos: [Video]
}
