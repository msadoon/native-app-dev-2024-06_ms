import Foundation
import Alamofire

/// Main singleton for sharing network requests app-wide.
class Networking {
    private let localHost = "http://localhost:4000/videos"
    static let shared = Networking()
    private var customDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z'"
        
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        
        return jsonDecoder
    }
    /**
     Use Alamofire to serialize the tweet timeline from a local file asynchronously.
     
     - Parameters:
         - fileName: The JSON formatted list of tweets.
     - Used Alamofire instead of `JSONSerialization` because it closely resembles a real world network request. In a real application we would get our data from a remote server. Robustness and community support have made Alamofire a reliable, production ready networking client. Extending this request for a real world request only requires updating `url` to the endpoint `String`.
     - Returns: Result type with either the decoded model data or an error.
     */
    func retrieveVideoInfo() async -> Result<[Video], AFError> {
        guard let url = URL(string: localHost) else {
            return .failure(.responseSerializationFailed(reason: .inputFileNil))
        }
        
        let dataTask = AF.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .serializingDecodable([Video].self, decoder: customDecoder)
        let result = await dataTask.result
        
        return result
    }
}
