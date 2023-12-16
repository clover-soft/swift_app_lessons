//
//  APIManager.swift
//  lesson03Hw01
//
//  Created by yakov on 12.12.2023.
//

import Foundation

final class APIManager {
    private let session: URLSession
    
    static private var token = ""
    static private var userId = ""

    static func setCredentials(_ token: String, _ userId: String) {
        self.token = token
        self.userId = userId
        print(token)
        print(userId)
    }
        
    enum Requests {
        case friends
        case groups
        case photos
    }
    
    static let shared = APIManager()
    
    private init() {
        session = URLSession.shared
    }
    
    private func getRequestUrl(for request: Requests) -> URL? {
        var urlString = ""
        
        switch request {
        case .friends:
            urlString = "https://api.vk.com/method/friends.get?fields=nickname,photo_50,online&access_token=\(APIManager.token)&v=5.199"
        case .groups:
            urlString = "https://api.vk.com/method/groups.get?extended=1&access_token=\(APIManager.token)&v=5.199"
        case .photos:
            urlString = "https://api.vk.com/method/photos.get?owner_id=\(APIManager.userId)&access_token=\(APIManager.token)&v=5.199&album_id=profile"
        }
        
        guard let url = URL(string: urlString) else {
            print("Error while creating URL")
            return nil
        }
        
        return url
    }
    
    func getData(for request: Requests, completion: @escaping ([Any]?) -> Void) {
        guard let url = getRequestUrl(for: request) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                switch request {
                case .friends:
                    let decodedData = try JSONDecoder().decode(FriendsModel.self, from: data)
                    completion(decodedData.response.items)
                    break
                case .groups:
                    let decodedData = try JSONDecoder().decode(GroupsModel.self, from: data)
                    completion(decodedData.response.items)
                    break
                case .photos:
                    var json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    let decodedData = try JSONDecoder().decode(PhotosModel.self, from: data)
                    completion(decodedData.response.items)
                    break
                }
            } catch {
                print(error)
                completion(nil)
            }
            
        }.resume()
    }
}
