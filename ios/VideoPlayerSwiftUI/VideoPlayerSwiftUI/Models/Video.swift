import Foundation
import Alamofire

/// Individual video model.
struct Video: Decodable, Identifiable {
    let id: String
    let title: String
    let hlsURL: URL
    let fullURL: URL
    let description: String
    let publishedAt: Date
    let author: Author
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case hlsURL
        case fullURL
        case description
        case publishedAt
        case author
    }
}
