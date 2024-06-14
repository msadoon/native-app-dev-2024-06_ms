import Foundation

/// Individual author model
struct Author: Decodable, Identifiable {
    let id: String
    let name: String
}
