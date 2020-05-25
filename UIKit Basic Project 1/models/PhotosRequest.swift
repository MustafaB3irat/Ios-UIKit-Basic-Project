import Foundation
import Alamofire

enum PhotoError: Error {
    case photosNotFound, invalidRequest
}

struct PhotosRequest {
    
    var apiURL: String
    
    
    init() {
        apiURL = "https://jsonplaceholder.typicode.com/photos"
    }
    
    func getPhotos(completion: @escaping (Result<[Int: [Photo]], PhotoError>) -> Void) {
        AF.request(apiURL).responseData { response in
            
            guard let data = response.data else {
                completion(.failure(.photosNotFound))
                return
            }
            
            do {
                var albums: [Int: [Photo]] = [:]
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                for photo in photos {
                    if albums[photo.albumId] == nil {
                        albums[photo.albumId] = [photo]
                    } else {
                        albums[photo.albumId]?.append(photo)
                    }
                }
                completion(.success(albums))
            } catch {
                completion(.failure(.invalidRequest))
            }
            
            
        }
    }
}
